class CreateDnsDomains < ActiveRecord::Migration[7.0]
  def change
    create_table :dns_domains do |t|
      t.text :domain
      t.references :user
      t.timestamps
    end
  end
end
