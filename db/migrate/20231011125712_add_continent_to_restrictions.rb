class AddContinentToRestrictions < ActiveRecord::Migration[7.0]
  def change
    add_column :restrictions, :continent, :text
  end
end
