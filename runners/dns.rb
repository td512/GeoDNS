require 'rubydns'
require 'domainatrix'

INTERFACES = [ 
        [:udp, "0.0.0.0", 5300],
        [:tcp, "0.0.0.0", 5300]
]

DNS = Resolv::DNS
RESOURCE = DNS::Resource
IN = RESOURCE::IN
A = IN::A
AAAA = IN::AAAA
CNAME = IN::CNAME
SRV = IN::SRV
MX = IN::MX
NS = IN::NS
PTR = IN::PTR
SOA = IN::SOA
TXT = IN::TXT
Name = DNS::Name

RubyDNS::run_server(INTERFACES) do
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

