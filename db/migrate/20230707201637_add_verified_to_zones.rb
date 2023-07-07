class AddVerifiedToZones < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :verified, :boolean
  end
end
