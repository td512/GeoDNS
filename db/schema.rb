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

ActiveRecord::Schema[7.0].define(version: 2023_07_07_202750) do
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

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "address"
    t.string "belongs_to"
    t.string "used"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "announcements", id: :serial, force: :cascade do |t|
    t.string "announcements"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "billings", id: :serial, force: :cascade do |t|
    t.string "owner"
    t.string "date_created"
    t.string "date_due"
    t.string "amount"
    t.string "paid"
    t.string "uuid"
    t.string "description"
    t.string "transaction_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "ip_pools", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "range_start"
    t.string "range_end"
    t.string "subnet_mask"
    t.string "gateway"
    t.string "owner"
    t.string "used"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "os_collections", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.string "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "os_templates", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "image_location"
    t.string "belongs_to"
    t.string "os_image"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "plans", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "cores"
    t.string "memory"
    t.string "hdd"
    t.string "used"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.string "owner"
    t.string "title"
    t.string "body"
    t.string "date"
    t.string "last_reply"
    t.string "status"
    t.string "ticket_id"
    t.string "ticket_num"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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

  create_table "vms", id: :serial, force: :cascade do |t|
    t.string "hostname"
    t.string "os"
    t.string "ip_address"
    t.string "disk"
    t.string "memory"
    t.string "traffic"
    t.string "uuid"
    t.string "owner"
    t.string "port"
    t.string "ws_port"
    t.string "vnc_pw"
    t.string "disk_uuid"
    t.string "hv"
    t.string "mac"
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
