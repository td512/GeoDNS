class CreateTickets < ActiveRecord::Migration[5.0]
  def change
    create_table :tickets do |t|
      t.string :owner
      t.string :title
      t.string :body
      t.string :date
      t.string :last_reply
      t.string :status
      t.string :ticket_id
      t.string :ticket_num
      t.timestamps
    end
  end
end
