class CreatePlans < ActiveRecord::Migration[5.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :cores
      t.string :memory
      t.string :hdd
      t.string :used
      t.timestamps
    end
  end
end
