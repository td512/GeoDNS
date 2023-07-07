class RenameNodeToZone < ActiveRecord::Migration[7.0]
  def change
    rename_table :nodes, :zones
  end
end
