class AddTypeToRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :record_type, :text
  end
end
