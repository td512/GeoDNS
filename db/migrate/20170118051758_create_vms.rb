class CreateVms < ActiveRecord::Migration[5.0]
  def change
    create_table :vms do |t|
      t.string :hostname
      t.string :os
      t.string :ip_address
      t.string :disk
      t.string :memory
      t.string :traffic
      t.string :uuid
      t.string :owner
      t.string :port
      t.string :ws_port
      t.string :vnc_pw
      t.string :disk_uuid
      t.string :hv
      t.string :mac
      t.timestamps
    end
  end
end
