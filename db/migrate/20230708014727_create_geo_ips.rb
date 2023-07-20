class CreateGeoIps < ActiveRecord::Migration[7.0]
  def change
    create_table :geo_ips do |t|
      t.text :continent
      t.text :country
      t.text :country_code
      t.text :state
      t.text :state_code
      t.text :city
      t.text :postal_code
      t.text :autonomous_system_number
      t.text :autonomous_system_organization
      t.text :isp
      t.text :organization
      t.text :connection_type

      t.timestamps
    end
  end
end
