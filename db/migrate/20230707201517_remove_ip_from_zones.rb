class RemoveIpFromZones < ActiveRecord::Migration[7.0]
  def change
    remove_column :zones, :ip
  end
end
