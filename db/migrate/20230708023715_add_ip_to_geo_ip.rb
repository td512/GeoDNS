class AddIpToGeoIp < ActiveRecord::Migration[7.0]
  def change
    add_column :geo_ips, :ip, :text
  end
end
