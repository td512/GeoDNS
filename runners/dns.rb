require 'rubydns'

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
DOMAINS = ['td512.dev', 'funce.dev']
RECORDS = ['a.td512.dev', 'b.funce.dev']

RubyDNS::run_server(INTERFACES) do
  otherwise do |transaction, query|
    puts "Question: #{transaction.question}"
    puts "Is Transaction ANAME? #{transaction.resource_class == A}"
    puts "Is Transaction AAAA? #{transaction.resource_class == AAAA}"
    puts "Is Transaction CNAME? #{transaction.resource_class == CNAME}"
    puts "Is Transaction SRV? #{transaction.resource_class == SRV}"
    puts "Is Transaction MX? #{transaction.resource_class == MX}"
    puts "Is Transaction NS? #{transaction.resource_class == NS}"
    puts "Is Transaction PTR? #{transaction.resource_class == PTR}"
    puts "Is Transaction SOA? #{transaction.resource_class == SOA}"
    puts "Is Transaction TXT? #{transaction.resource_class == TXT}"
  end
end

