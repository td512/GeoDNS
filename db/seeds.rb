# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require File.join(Rails.root, 'lib', 'geoip.rb')
require 'io/console'
$stdout.clear_screen
puts "Checking for #{File.join(Rails.root, 'geoip', 'geodns.sql')}"
exit 1 unless File.exist?(File.join(Rails.root, 'geoip', 'geodns.sql'))
system("DISABLE_SPRING=true rails db < #{File.join(Rails.root, "geoip", "geodns.sql")}", out: STDOUT)
puts "(INFO) Seed complete! You can now start the server."