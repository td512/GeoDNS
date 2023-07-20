require 'maxmind/geoip2'

module GeoIP
  class << self

    LIST_URL = "http://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt"
    last_update = Time.current

    def addresses
      @addresses ||= load
      if last_update + 6.hours < Time.current
        @addresses = load
      end
    end

    def load
      bogons = []

      Net::HTTP.get(URI.parse(LIST_URL)).each_line do |line|
        if line !~ /^#/
          bogons << IPAddr.new(line.chomp)
        end
      end

      @addresses = bogons
    end

    def bogon?(addr)
      addr = IPAddr.new(addr)

      addresses.any? { |range| range.include?(addr) }
    end
  end
end