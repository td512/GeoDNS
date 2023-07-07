class CreateOsTemplates < ActiveRecord::Migration[5.0]
  def change
    create_table :os_templates do |t|
      t.string :name
      t.string :image_location
      t.string :belongs_to
      t.string :os_image
      t.timestamps
    end
  end
end
