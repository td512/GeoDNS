class AddLongitudeToGeoIp < ActiveRecord::Migration[7.0]
  def change
    add_column :geo_ips, :longitude, :text
  end
end
