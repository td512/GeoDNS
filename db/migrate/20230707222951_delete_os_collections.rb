class DeleteOsCollections < ActiveRecord::Migration[7.0]
  def change
    drop_table :os_collections
  end
end
