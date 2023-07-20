require 'ipaddr'

@city = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-City.mmdb')
)
@isp = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-ISP.mmdb')
)
@connection_type = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-Connection-Type.mmdb')
)
start_ip = IPAddr.new(ARGV[0])
end_ip = IPAddr.new(ARGV[1])
(start_ip..end_ip).each do |ip|
  ip = ip.to_s
  unless GeoIp.find_by(ip: ip)
    begin
      ip_city = @city.city(ip)
      ip_isp = @isp.isp(ip)
      ip_connection_type = @connection_type.connection_type(ip)
      GeoIp.create!(
        ip:,
        continent: ip_city.continent.code,
        country: ip_city.country.name,
        country_code: ip_city.country.iso_code,
        state: ip_city.most_specific_subdivision.name,
        state_code: ip_city.most_specific_subdivision.iso_code,
        postal_code: ip_city.postal.code,
        latitude: ip_city.location.latitude,
        longitude: ip_city.location.longitude,
        autonomous_system_number: ip_isp.autonomous_system_number,
        autonomous_system_organization: ip_isp.autonomous_system_organization,
        isp: ip_isp.isp,
        organization: ip_isp.organization,
        connection_type: ip_connection_type.connection_type
      )
      puts "(INFO) [#{ip_isp.autonomous_system_organization}] #{ip} Successfully imported from MaxMind Database. Country is #{ip_city.country.name}. Connection Type: #{ip_connection_type.connection_type}"
    rescue MaxMind::GeoIP2::AddressNotFoundError
      puts "(INFO) Address #{ip} wasn't found in the MaxMind Database."
    end
    ip_isp = nil
    ip_city = nil
    ip_connection_type = nil
    ip = nil
  else
    puts "(INFO) We've already imported this IP. Moving on."
  end
end