class AddLatitudeToGeoIp < ActiveRecord::Migration[7.0]
  def change
    add_column :geo_ips, :latitude, :text
  end
end
