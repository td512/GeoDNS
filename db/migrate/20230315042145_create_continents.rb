class CreateContinents < ActiveRecord::Migration[7.0]
  def change
    create_table :continents do |t|
      t.integer :name, limit: 1

      t.timestamps
      t.index :name
    end
  end
end
