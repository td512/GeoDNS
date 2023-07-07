class DeleteTickets < ActiveRecord::Migration[7.0]
  def change
    drop_table :tickets
  end
end
