require 'rubydns'
require 'domainatrix'
require_relative '../lib/geoip.rb'

GeoIP.load

INTERFACES = [
  [:udp, "0.0.0.0", 53],
  [:tcp, "0.0.0.0", 53]
]

Name = Resolv::DNS::Name

RubyDNS::run_server(INTERFACES) do
  match(//, Resolv::DNS::Resource::IN::SOA) do |transaction|
    transaction.respond!(
      Name.create('katie.td512.dev'),    # Master Name
      Name.create('dns.theom.nz.'), # Responsible Name
      File.mtime(__FILE__).to_i,          # Serial Number
      1800,                               # Refresh Time
      900,                                # Retry Time
      3_600_000,                          # Maximum TTL / Expiry Time
      172_800                             # Minimum TTL
    )
    transaction.append!(transaction.question, Resolv::DNS::Resource::IN::NS, section: :authority)
  end
  otherwise do |transaction|
    client = transaction.options[:remote_address].ip_address
    network = GeoIp2Network.where("network >>= '#{client}'")
                           .joins("LEFT JOIN geo_ip2_locations ON geo_ip2_networks.geoname_id = geo_ip2_locations.geoname_id")
                           .select("geo_ip2_networks.*, geo_ip2_locations.*").first
    connection_type = GeoIp2ConnectionType.where("network >>= '#{client}'").first
    isp = GeoIp2Isp.where("network >>= '#{client}'").first
    # Works round method overloads
    question = "#{transaction.question}".downcase
    puts "Processing DNS Question for #{question}. Client appears to be from #{network&.country_name || '*** BOGON IP. REFUSING TO RESPOND ***'}."
    host = Domainatrix.parse(question)
    domain = "#{host.domain}.#{host.public_suffix}"
    record = host.subdomain
    record = "@" if record.empty?
    domain = Zone.find_by(name: domain)
    response = []
    timeout = []

    # If we don't know about the Zone we should halt execution here
    unless domain.nil?
      #      transaction.fail!(:NXDomain)
      records = Record.where(name: record, owner: domain.id, record_type: "#{transaction.resource_class}")
      if ! records
        transaction.fail!(:NXDomain)
      elsif GeoIP.bogon?(client)
        transaction.fail!(:ServFail)
      else
        records.each do |record|
          restrictions = Restriction.where(owner: record.id)
          response_code = true
          restrictions.each do |r|
            next unless r.enabled
            if r.allow
              if r.continent
                response_code = false unless network .continent_code == r.continent
              end
              if r.country
                response_code = false unless network.country_name == r.country
              end
              if r.state
                response_code = false unless network.subdivision_1_name == r.state
              end
              if r.city
                response_code = false unless network.city_name == r.city
              end
              if r.isp
                response_code = false unless isp.isp == r.isp
              end
              if r.asn
                response_code = false unless isp.autonomous_system_number == r.asn
              end
              if r.connection_type
                response_code = false unless connection_type.connection_type == r.connection_type
              end
            else
              if r.continent
                response_code = false unless network.continent_code != r.continent
              end
              if r.country
                response_code = false unless network.country_name != r.country
              end
              if r.state
                response_code = false unless network.subdivision_1_name != r.state
              end
              if r.city
                response_code = false unless network.city_name != r.city
              end
              if r.isp
                response_code = false unless isp.isp != r.isp
              end
              if r.asn
                response_code = false unless isp.autonomous_system_number != r.asn
              end
              if r.connection_type
                response_code = false unless connection_type.connection_type != r.connection_type
              end
            end
          end
          if response_code
            response.push(record.value)
            timeout.push(record.ttl)
          end
        end
        if ! GeoIP.bogon?(client) && response.present?
          response.each_with_index do |r, i|
            if "#{transaction.resource_class}" == "Resolv::DNS::Resource::IN::NS"
              transaction.respond!(Name.create(r), {ttl: (timeout[i] || 3600)})
            else
              transaction.respond!(r, {ttl: (timeout[i] || 3600)})
            end
          end
        else
          transaction.fail!(:Refused)
        end

      end
    else
      transaction.fail!(:NXDomain)
    end
  end
end