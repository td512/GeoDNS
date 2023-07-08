require 'maxmind/geoip2'

module GeoIP
  class << self
    def ip_info?(ip)
      {
        geolocation: geolocation(ip),
        isp: isp(ip),
        connection_type: connection_type(ip)
      }
    end

    def geolocation(ip)
      ip = mmdb(File.join("geoip", "GeoIP2-City.mmdb")).city(ip)
      {
        continent: ip.continent.code,
        country: ip.country.name,
        state: ip.most_specific_subdivision.name,
        city: ip.city.name,
        postal_code: ip.postal.code
      }
    end

    def isp(ip)
      ip = mmdb(File.join("geoip", "GeoIP2-ISP.mmdb")).isp(ip)

      {
       asn: ip.autonomous_system_number,
       aso: ip.autonomous_system_organization,
       isp: ip.isp,
       org: ip.organization
      }
    end

    def connection_type(ip)
      mmdb(File.join("geoip", "GeoIP2-Connection-Type.mmdb")).connection_type(ip).connection_type
    end

    private

    def mmdb(mmdb)
      MaxMind::GeoIP2::Reader.new(
        database: File.join(Rails.root, file),
        )
    end
  end
end