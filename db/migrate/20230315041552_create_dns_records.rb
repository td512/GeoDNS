class CreateDnsRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :dns_records do |t|
      t.text :host
      t.number :record_type
      t.references :domain
      t.number :hits
      t.boolean :geolocation_enabled
      t.number :continent
      t.text :country
      t.text :city
      t.timestamps
    end
  end
end
