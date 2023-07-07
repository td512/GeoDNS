class AddRouteTokenToZones < ActiveRecord::Migration[7.0]
  def change
    add_column :zones, :route_token, :text
  end
end
