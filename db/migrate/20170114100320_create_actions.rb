class CreateActions < ActiveRecord::Migration[5.0]
  def change
    create_table :actions do |t|
      t.string :action
      t.string :owner
      t.string :ip
      t.string :date
      t.string :status
      t.timestamps
    end
  end
end
