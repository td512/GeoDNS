class CreateContinents < ActiveRecord::Migration[7.0]
  def change
    create_table :continents do |t|
      t.text :name
      t.timestamps
    end
  end
end
