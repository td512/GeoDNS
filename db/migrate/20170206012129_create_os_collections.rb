class CreateOsCollections < ActiveRecord::Migration[5.0]
  def change
    create_table :os_collections do |t|
      t.string :name
      t.string :url
      t.string :description
      t.timestamps
    end
  end
end
