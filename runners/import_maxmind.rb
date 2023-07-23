require 'ipaddr'
require 'concurrent'
require 'yaml'
require 'parallel'
require 'fileutils'
require 'progressbar'
require 'io/console'

schedulable_processors = Concurrent.processor_count - 2
schedulable_processors = 1 if schedulable_processors < 1
FileUtils.rm_rf(File.join(Rails.root, 'tmp', 'seed-root'))
FileUtils.mkdir_p(File.join(Rails.root, 'tmp', 'seed-root'))

def import_records(network, subnet)
  start_ip = IPAddr.new("#{network}.#{subnet}.0.0")
  end_ip = IPAddr.new("#{network}.#{subnet}.255.255")
  rows = []
  (start_ip..end_ip).each do |ip|
    ip = ip.to_s
    begin
      ip_city = @city.city(ip)
      ip_isp = @isp.isp(ip)
      ip_connection_type = @connection_type.connection_type(ip)
      rows.push({
                  ip:,
                  continent: ip_city&.continent&.code,
                  country: ip_city&.country&.name,
                  country_code: ip_city&.country&.iso_code,
                  state: ip_city&.most_specific_subdivision&.name,
                  state_code: ip_city&.most_specific_subdivision&.iso_code,
                  city: ip_city&.city&.name,
                  postal_code: ip_city&.postal.code,
                  latitude: ip_city&.location&.latitude,
                  longitude: ip_city&.location&.longitude,
                  autonomous_system_number: ip_isp&.autonomous_system_number,
                  autonomous_system_organization: ip_isp&.autonomous_system_organization,
                  isp: ip_isp.isp,
                  organization: ip_isp.organization,
                  connection_type: ip_connection_type.connection_type
                })
      puts "(INFO) [#{ip_isp&.autonomous_system_organization}] #{ip} Successfully imported from MaxMind Database. Locality is #{ip_city&.city&.name}, #{ip_city&.country&.name}, Connection Type: #{ip_connection_type.connection_type}"
    rescue MaxMind::GeoIP2::AddressNotFoundError
      puts "(INFO) Address #{ip} wasn't found in the MaxMind Database. Inserting as bogon."
      rows.push({
                  ip:,
                  country: 'BOGON',
                  country_code: 'ZZ',
                  connection_type: 'BOGON'
                })
    end
    ip_isp = nil
    ip_city = nil
    ip_connection_type = nil
    ip = nil
  end
  File.open((File.join(Rails.root, 'tmp', 'seed-root', "#{network}.#{subnet}.0.0.yaml")), 'w') { |f| f.write(rows.to_yaml) }
end

@city = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-City.mmdb')
)
@isp = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-ISP.mmdb')
)
@connection_type = MaxMind::GeoIP2::Reader.new(
  database: File.join(Rails.root, 'geoip', 'GeoIP2-Connection-Type.mmdb')
)

network = ARGV[0]
counter = 1
rows = []

puts "(INFO) Spawning #{schedulable_processors} threads"
Parallel.each((0..255), in_processes: schedulable_processors) do |subnet|
  import_records(network, subnet)
end
$stdout.clear_screen
puts "(INFO) Importing records into database. This may take a while. Please be patient."
progressbar = ProgressBar.create(format: '%a |%b>%i| %p%% (%c/%C) %E',
                   title: "Records",
                   total: 1,
                   starting_at: 0)
16_777_215.times { progressbar.total += 1 }
(0..255).each do |subnet|
  rows += YAML.load(
    File.read(
      File.join(
        Rails.root, 'tmp', 'seed-root', "#{network}.#{subnet}.0.0.yaml" )
      )
  )
  GeoIp.insert_all!(rows)
  65_536.times { progressbar.increment }
  rows.clear
end
FileUtils.rm_rf(File.join(Rails.root, 'tmp', 'seed-root'))
exit 0
