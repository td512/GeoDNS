class CreateIpPools < ActiveRecord::Migration[5.0]
  def change
    create_table :ip_pools do |t|
      t.string :name
      t.string :range_start
      t.string :range_end
      t.string :subnet_mask
      t.string :gateway
      t.string :owner
      t.string :used
      t.timestamps
    end
  end
end
