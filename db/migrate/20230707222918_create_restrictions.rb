class CreateRestrictions < ActiveRecord::Migration[7.0]
  def change
    create_table :restrictions do |t|
      t.integer :owner
      t.boolean :allow
      t.boolean :enabled
      t.text :country
      t.text :state
      t.text :city
      t.text :isp
      t.text :connection_type
      t.text :asn

      t.timestamps
    end
  end
end
