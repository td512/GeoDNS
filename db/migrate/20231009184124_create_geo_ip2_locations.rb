class CreateGeoIp2Locations < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_ip2_locations do |t|
      t.integer :geoname_id
      t.text :locale_code
      t.text :continent_code
      t.text :continent_name
      t.text :country_iso_code
      t.text :country_name
      t.text :subdivision_1_iso_code
      t.text :subdivision_1_name
      t.text :subdivision_2_iso_code
      t.text :subdivision_2_name
      t.text :city_name
      t.integer :metro_code
      t.text :time_zone
      t.boolean :is_in_european_union
    end
  end
end
