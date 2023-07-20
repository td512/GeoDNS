# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require File.join(Rails.root, 'lib', 'geoip.rb')
puts "Checking for #{File.join(Rails.root, 'geoip', 'GeoIP2-City.mmdb')}"
exit 1 unless File.exist?(File.join(Rails.root, 'geoip', 'GeoIP2-City.mmdb'))
puts "Checking for #{File.join(Rails.root, 'geoip', 'GeoIP2-ISP.mmdb')}"
exit 1 unless File.exist?(File.join(Rails.root, 'geoip', 'GeoIP2-ISP.mmdb'))
puts "Checking for #{File.join(Rails.root, 'geoip', 'GeoIP2-Connection-Type.mmdb')}"
exit 1 unless File.exist?(File.join(Rails.root, 'geoip', 'GeoIP2-Connection-Type.mmdb'))
puts "Warning! Warning! Warning! Warning! Warning! Warning! Warning! Warning!"
puts "(WARN) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts "(WARN) This process will take a *very* long time to complete."
puts "(WARN) If you do not have the time to wait you should hit CTRL+C NOW"
puts "(WARN) Waiting 5 seconds before beginning import of GeoIP2 Databases"
puts "(WARN) !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
puts "Warning! Warning! Warning! Warning! Warning! Warning! Warning! Warning!"
sleep 5
puts "(INFO) Starting to create records in the database. This process WILL"
puts "(INFO) a very long time. Please be patient, even if the seed appears"
puts "(INFO) to be frozen."
(0..255).each do |network|
    start_ip = "#{network}.0.0.0"
    end_ip = "#{network}.255.255.255"
    system("DISABLE_SPRING=true rails runner #{File.join(Rails.root, "runners", "import_maxmind.rb")} #{start_ip} #{end_ip}", out: STDOUT)
end