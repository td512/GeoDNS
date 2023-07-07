class DeleteIpPools < ActiveRecord::Migration[7.0]
  def change
    drop_table :ip_pools
  end
end
