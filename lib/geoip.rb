module GeoIP
  class << self

    LIST_URL = "https://www.team-cymru.org/Services/Bogons/fullbogons-ipv4.txt"
    @last_update = Time.current

    def addresses
      @addresses
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