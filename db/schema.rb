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

ActiveRecord::Schema.define(version: 20180305202245) do

  create_table "characteristics", force: :cascade do |t|
    t.string "type", null: false
    t.string "value"
    t.integer "service_id", null: false
    t.index ["service_id"], name: "index_characteristics_on_service_id"
  end

  create_table "instances", force: :cascade do |t|
    t.string "attributable_type"
    t.integer "attributable_id"
    t.index ["attributable_type", "attributable_id"], name: "index_instances_on_attributable_type_and_attributable_id"
  end

  create_table "pairings", force: :cascade do |t|
    t.string "identifier", null: false
    t.string "public_key", null: false
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_pairings_on_identifier"
  end

  create_table "services", force: :cascade do |t|
    t.string "type", null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "primary", default: false, null: false
    t.integer "accessory_id", default: 1, null: false
  end

end