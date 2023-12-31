# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_11_125712) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actions", id: :serial, force: :cascade do |t|
    t.string "action"
    t.string "owner"
    t.string "ip"
    t.string "date"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "announcements", id: :serial, force: :cascade do |t|
    t.string "announcements"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "geo_ip2_connection_types", force: :cascade do |t|
    t.cidr "network"
    t.text "connection_type"
  end

  create_table "geo_ip2_isps", force: :cascade do |t|
    t.cidr "network"
    t.text "isp"
    t.text "organization"
    t.integer "autonomous_system_number"
    t.text "autonomous_system_organization"
    t.string "mobile_country_code"
    t.string "mobile_network_code"
  end

  create_table "geo_ip2_locations", force: :cascade do |t|
    t.integer "geoname_id"
    t.text "locale_code"
    t.text "continent_code"
    t.text "continent_name"
    t.text "country_iso_code"
    t.text "country_name"
    t.text "subdivision_1_iso_code"
    t.text "subdivision_1_name"
    t.text "subdivision_2_iso_code"
    t.text "subdivision_2_name"
    t.text "city_name"
    t.integer "metro_code"
    t.text "time_zone"
    t.boolean "is_in_european_union"
  end

  create_table "geo_ip2_networks", force: :cascade do |t|
    t.cidr "network"
    t.integer "geoname_id"
    t.integer "registered_country_geoname_id"
    t.integer "represented_country_geoname_id"
    t.boolean "is_anonymous_proxy"
    t.boolean "is_satellite_provider"
    t.text "postal_code"
    t.float "latitude"
    t.float "longitude"
    t.integer "accuracy_radius"
  end

  create_table "geo_ips", force: :cascade do |t|
    t.text "continent"
    t.text "country"
    t.text "country_code"
    t.text "state"
    t.text "state_code"
    t.text "city"
    t.text "postal_code"
    t.text "autonomous_system_number"
    t.text "autonomous_system_organization"
    t.text "isp"
    t.text "organization"
    t.text "connection_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "latitude"
    t.text "longitude"
    t.text "ip"
  end

  create_table "records", force: :cascade do |t|
    t.text "name"
    t.integer "owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "record_type"
    t.text "value"
    t.integer "ttl"
  end

  create_table "restrictions", force: :cascade do |t|
    t.integer "owner"
    t.boolean "allow"
    t.boolean "enabled"
    t.text "country"
    t.text "state"
    t.text "city"
    t.text "isp"
    t.text "connection_type"
    t.text "asn"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "continent"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "password_digest"
    t.string "reset"
    t.string "activation_code"
    t.boolean "activated"
    t.string "token"
    t.string "original_token"
    t.string "style"
    t.integer "level"
    t.boolean "enabled"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "zones", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "verified"
    t.integer "owner"
    t.text "route_token"
  end

end
