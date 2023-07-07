class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
      t.string :owner
      t.string :date_created
      t.string :date_due
      t.string :amount
      t.string :paid
      t.string :uuid
      t.string :description
      t.string :transaction_id
      t.timestamps
    end
  end
end
