class DeleteOsTemplates < ActiveRecord::Migration[7.0]
  def change
    drop_table :os_templates
  end
end
