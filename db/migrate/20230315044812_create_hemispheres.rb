class CreateHemispheres < ActiveRecord::Migration[7.0]
  def change
    create_table :hemispheres do |t|
      t.text :name

      t.timestamps
    end
  end
end
