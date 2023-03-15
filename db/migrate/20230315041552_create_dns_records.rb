class CreateDnsRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :dns_records do |t|
      t.string :host
      t.integer :record_type
      t.references :domain
      t.integer :hits
      t.boolean :geolocation_enabled
      t.integer :continent
      t.string :country
      t.text :city
      t.timestamps

      t.index :host
      t.index :record_type
      t.index :continent
      t.index :country
    end
  end
end
