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

ActiveRecord::Schema.define(version: 2016_08_03_143148) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "caddie_crest_price_history_last_day_timestamps", id: :serial, force: :cascade do |t|
    t.integer "eve_item_id"
    t.integer "region_id"
    t.datetime "day_timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["region_id", "eve_item_id"], name: "index_caddie_crest_price_history_last_day_timestamps", unique: true
  end

  create_table "caddie_crest_price_history_update_logs", id: :serial, force: :cascade do |t|
    t.date "feed_date"
    t.integer "update_planning_time"
    t.integer "feeding_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "total_inserts"
    t.float "co_seconds"
    t.index ["feed_date"], name: "index_caddie_crest_price_history_update_logs_on_feed_date", unique: true
  end

  create_table "caddie_crest_price_history_updates", id: :serial, force: :cascade do |t|
    t.integer "eve_item_id"
    t.integer "region_id"
    t.date "max_update"
    t.date "max_eve_item_create"
    t.date "max_region_create"
    t.date "max_date"
    t.integer "nb_days"
    t.string "process_queue"
    t.integer "process_queue_priority"
    t.date "next_process_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "thread_slice_id"
    t.index ["eve_item_id", "region_id"], name: "index_caddie_cphu_on_eve_item_id_and_region_id", unique: true
    t.index ["nb_days"], name: "index_caddie_crest_price_history_updates_on_nb_days"
    t.index ["next_process_date"], name: "index_caddie_crest_price_history_updates_on_next_process_date"
    t.index ["process_queue"], name: "index_caddie_crest_price_history_updates_on_process_queue"
    t.index ["thread_slice_id"], name: "index_caddie_crest_price_history_updates_on_thread_slice_id"
  end

  create_table "crest_price_histories", id: :serial, force: :cascade do |t|
    t.integer "region_id", null: false
    t.integer "eve_item_id", null: false
    t.datetime "history_date", null: false
    t.bigint "order_count"
    t.bigint "volume"
    t.float "low_price"
    t.float "avg_price"
    t.float "high_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["history_date"], name: "index_crest_price_histories_on_history_date"
    t.index ["region_id", "eve_item_id"], name: "index_crest_price_histories_on_region_and_item"
  end

  create_table "eve_items", id: :serial, force: :cascade do |t|
    t.integer "cpp_eve_item_id"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "name_lowcase"
    t.float "cost"
    t.boolean "epic_blueprint", default: false
    t.boolean "involved_in_blueprint", default: false
    t.integer "market_group_id"
    t.index ["cpp_eve_item_id"], name: "index_eve_items_on_cpp_eve_item_id"
    t.index ["market_group_id"], name: "index_eve_items_on_market_group_id"
  end

  create_table "regions", id: :serial, force: :cascade do |t|
    t.string "cpp_region_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpp_region_id"], name: "index_regions_on_cpp_region_id", unique: true
  end

  add_foreign_key "caddie_crest_price_history_last_day_timestamps", "eve_items"
  add_foreign_key "caddie_crest_price_history_last_day_timestamps", "regions"
  add_foreign_key "caddie_crest_price_history_updates", "eve_items"
  add_foreign_key "caddie_crest_price_history_updates", "regions"
  add_foreign_key "crest_price_histories", "eve_items"
  add_foreign_key "crest_price_histories", "regions"
end
