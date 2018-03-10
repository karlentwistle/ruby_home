# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180306223336) do

  create_table "accessories", force: :cascade do |t|
  end

  create_table "characteristics", force: :cascade do |t|
    t.integer "instance_id", null: false
    t.integer "accessory_id", null: false
    t.integer "service_id", null: false
    t.string "type", null: false
    t.string "value"
    t.index ["accessory_id"], name: "index_characteristics_on_accessory_id"
    t.index ["service_id"], name: "index_characteristics_on_service_id"
  end

  create_table "services", force: :cascade do |t|
    t.boolean "hidden", default: false, null: false
    t.boolean "primary", default: false, null: false
    t.integer "instance_id", null: false
    t.integer "accessory_id", null: false
    t.string "type", null: false
    t.index ["accessory_id"], name: "index_services_on_accessory_id"
  end

end
