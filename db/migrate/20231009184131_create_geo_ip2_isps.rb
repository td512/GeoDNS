class CreateGeoIp2Isps < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_ip2_isps do |t|
      t.cidr :network
      t.text :isp
      t.text :organization
      t.integer :autonomous_system_number
      t.text :autonomous_system_organization
      t.string :mobile_country_code
      t.string :mobile_network_code
    end
  end
end
