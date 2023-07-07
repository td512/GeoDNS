class RemoveVmCountFromZones < ActiveRecord::Migration[7.0]
  def change
    remove_column :zones, :vm_count
  end
end
