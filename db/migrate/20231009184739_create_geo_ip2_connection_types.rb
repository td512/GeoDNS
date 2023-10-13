class CreateGeoIp2ConnectionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_ip2_connection_types do |t|
      t.cidr :network
      t.text :connection_type
    end
  end
end
