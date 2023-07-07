class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :reset
      t.string :activation_code
      t.boolean :activated
      t.string :token
      t.string :original_token
      t.string :style
      t.integer :level
      t.boolean :enabled
      t.timestamps
    end
  end
end
