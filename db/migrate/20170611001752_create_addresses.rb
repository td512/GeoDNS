class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :belongs_to
      t.string :used
      t.timestamps
    end
  end
end
