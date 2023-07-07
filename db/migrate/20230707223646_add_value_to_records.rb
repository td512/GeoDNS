class AddValueToRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :value, :text
  end
end
