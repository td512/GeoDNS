class CreateGeoIp2Networks < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_ip2_networks do |t|
      t.cidr :network
      t.integer :geoname_id
      t.integer :registered_country_geoname_id
      t.integer :represented_country_geoname_id
      t.boolean :is_anonymous_proxy
      t.boolean :is_satellite_provider
      t.text :postal_code
      t.float :latitude
      t.float :longitude
      t.integer :accuracy_radius
    end
  end
end
