class AddTtlToRecord < ActiveRecord::Migration[7.0]
  def change
    add_column :records, :ttl, :integer
  end
end
