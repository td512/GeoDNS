require 'rubydns'
require 'domainatrix'



INTERFACES = [ 
        [:udp, "0.0.0.0", 5300],
        [:tcp, "0.0.0.0", 5300]
]

Name = Resolv::DNS::Name

RubyDNS::run_server(INTERFACES) do
  match(//, Resolv::DNS::Resource::IN::SOA) do |transaction|
    transaction.respond!(
      Name.create('ns.chasedns.nz'),    # Master Name
      Name.create('hello.chase.net.nz.'), # Responsible Name
      File.mtime(__FILE__).to_i,          # Serial Number
      1800,                               # Refresh Time
      900,                                # Retry Time
      3_600_000,                          # Maximum TTL / Expiry Time
      172_800                             # Minimum TTL
    )
    transaction.append!(transaction.question, Resolv::DNS::Resource::IN::NS, section: :authority)
  end
  otherwise do |transaction, query|
    # Works round method overloads
    question = "#{transaction.question}"
    puts "Processing DNS Question for #{question}"
    host = Domainatrix.parse(question)
    domain = "#{host.domain}.#{host.public_suffix}"
    record = host.subdomain
    domain = Zone.find_by(name: domain)
    # If we don't know about the Zone we should halt execution here
    unless domain.nil?
      transaction.fail!(:NXDomain)
      record = Record.find_by(name: record, owner: domain.id, record_type: "#{transaction.resource_class}")
      if record.nil?
        transaction.fail!(:NXDomain)
      else
        transaction.respond!(record.value, {ttl: (record.ttl || 3600)})
      end
    else
      transaction.fail!(:NXDomain)
    end
  end
end

