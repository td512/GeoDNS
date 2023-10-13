require 'whois'
require 'whois-parser'

zones = Zone.where(verified: false).or(Zone.where(verified: nil)).limit(10)

zones.each do |zone|
  puts "Starting WHOIS lookup for Zone #{zone}"
  whois = Whois.whois(zone)
  record = whois.parser
  nameservers = []
  record.nameservers.each { |ns| nameservers.push(ns) }
  verified = true if (nameservers.include? "theo.ns.chasedns.nz" && nameservers.include? "connor.ns.chasedns.nz") && nameservers.length == 2
  if verified
    puts "Successfully verified Zone #{zone}"
    zone.verified = true
    zone.save!
  else
    puts "Failed to verify Zone #{zone}"
  end
end
sleep 30