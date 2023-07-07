class AddOwnerToZones < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :owner, :integer
  end
end
