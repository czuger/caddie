# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160810133553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blueprints", force: :cascade do |t|
    t.integer  "eve_item_id"
    t.integer  "nb_runs"
    t.integer  "prod_qtt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cpp_blueprint_id"
  end

  add_index "blueprints", ["cpp_blueprint_id"], name: "index_blueprints_on_cpp_blueprint_id", using: :btree
  add_index "blueprints", ["eve_item_id"], name: "index_blueprints_on_eve_item_id", using: :btree

  create_table "caddie_crest_price_history_last_day_timestamps", force: :cascade do |t|
    t.integer  "eve_item_id"
    t.integer  "region_id"
    t.datetime "day_timestamp"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "caddie_crest_price_history_last_day_timestamps", ["region_id", "eve_item_id"], name: "index_caddie_crest_price_history_last_day_timestamps", unique: true, using: :btree

  create_table "caddie_crest_price_history_update_logs", force: :cascade do |t|
    t.date     "feed_date"
    t.integer  "update_planning_time"
    t.integer  "feeding_time"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.integer  "total_inserts"
    t.float    "co_seconds"
  end

  add_index "caddie_crest_price_history_update_logs", ["feed_date"], name: "index_caddie_crest_price_history_update_logs_on_feed_date", unique: true, using: :btree

  create_table "caddie_crest_price_history_updates", force: :cascade do |t|
    t.integer  "eve_item_id"
    t.integer  "region_id"
    t.date     "max_update"
    t.date     "max_eve_item_create"
    t.date     "max_region_create"
    t.date     "max_date"
    t.integer  "nb_days"
    t.string   "process_queue"
    t.integer  "process_queue_priority"
    t.date     "next_process_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "thread_slice_id"
  end

  add_index "caddie_crest_price_history_updates", ["eve_item_id", "region_id"], name: "index_caddie_cphu_on_eve_item_id_and_region_id", unique: true, using: :btree
  add_index "caddie_crest_price_history_updates", ["nb_days"], name: "index_caddie_crest_price_history_updates_on_nb_days", using: :btree
  add_index "caddie_crest_price_history_updates", ["next_process_date"], name: "index_caddie_crest_price_history_updates_on_next_process_date", using: :btree
  add_index "caddie_crest_price_history_updates", ["process_queue"], name: "index_caddie_crest_price_history_updates_on_process_queue", using: :btree
  add_index "caddie_crest_price_history_updates", ["thread_slice_id"], name: "index_caddie_crest_price_history_updates_on_thread_slice_id", using: :btree

  create_table "caddie_price_advices", force: :cascade do |t|
    t.integer  "eve_item_id",                    null: false
    t.integer  "trade_hub_id",                   null: false
    t.integer  "region_id"
    t.integer  "vol_month",            limit: 8
    t.integer  "vol_day",              limit: 8
    t.float    "cost"
    t.float    "min_price"
    t.float    "avg_price"
    t.float    "margin_pcent_daily"
    t.float    "margin_isk_daily"
    t.float    "margin_pcent_monthly"
    t.float    "margin_isk_monthly"
    t.float    "daily_monthly_pcent"
    t.integer  "adjusted_batch_size"
    t.integer  "prod_qtt"
    t.float    "single_unit_cost"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "caddie_price_advices", ["eve_item_id"], name: "index_caddie_price_advices_on_eve_item_id", using: :btree
  add_index "caddie_price_advices", ["region_id"], name: "index_caddie_price_advices_on_region_id", using: :btree
  add_index "caddie_price_advices", ["trade_hub_id"], name: "index_caddie_price_advices_on_trade_hub_id", using: :btree

  create_table "crest_price_histories", force: :cascade do |t|
    t.integer  "region_id",              null: false
    t.integer  "eve_item_id",            null: false
    t.datetime "history_date",           null: false
    t.integer  "order_count",  limit: 8
    t.integer  "volume",       limit: 8
    t.float    "low_price"
    t.float    "avg_price"
    t.float    "high_price"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "crest_price_histories", ["history_date"], name: "index_crest_price_histories_on_history_date", using: :btree
  add_index "crest_price_histories", ["region_id", "eve_item_id"], name: "index_crest_price_histories_on_region_and_item", using: :btree

  create_table "crest_prices_last_month_averages", force: :cascade do |t|
    t.integer  "region_id",                 null: false
    t.integer  "eve_item_id",               null: false
    t.integer  "order_count_sum", limit: 8
    t.integer  "volume_sum",      limit: 8
    t.integer  "order_count_avg", limit: 8
    t.integer  "volume_avg",      limit: 8
    t.float    "low_price_avg"
    t.float    "avg_price_avg"
    t.float    "high_price_avg"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "crest_prices_last_month_averages", ["eve_item_id"], name: "index_crest_prices_last_month_averages_on_eve_item_id", using: :btree
  add_index "crest_prices_last_month_averages", ["region_id", "eve_item_id"], name: "prices_lmavg_all_keys_index", unique: true, using: :btree
  add_index "crest_prices_last_month_averages", ["region_id"], name: "index_crest_prices_last_month_averages_on_region_id", using: :btree

  create_table "eve_items", force: :cascade do |t|
    t.integer  "cpp_eve_item_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name_lowcase"
    t.float    "cost"
    t.boolean  "epic_blueprint",        default: false
    t.boolean  "involved_in_blueprint", default: false
    t.integer  "market_group_id"
  end

  add_index "eve_items", ["cpp_eve_item_id"], name: "index_eve_items_on_cpp_eve_item_id", using: :btree
  add_index "eve_items", ["market_group_id"], name: "index_eve_items_on_market_group_id", using: :btree

  create_table "min_prices", force: :cascade do |t|
    t.integer  "eve_item_id"
    t.integer  "trade_hub_id"
    t.float    "min_price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "min_prices", ["eve_item_id"], name: "index_min_prices_on_eve_item_id", using: :btree
  add_index "min_prices", ["trade_hub_id"], name: "index_min_prices_on_trade_hub_id", using: :btree

  create_table "regions", force: :cascade do |t|
    t.string   "cpp_region_id", null: false
    t.string   "name",          null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "regions", ["cpp_region_id"], name: "index_regions_on_cpp_region_id", unique: true, using: :btree

  create_table "trade_hubs", force: :cascade do |t|
    t.integer  "eve_system_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "region_id"
    t.boolean  "inner",         default: false
  end

  add_index "trade_hubs", ["region_id"], name: "index_trade_hubs_on_region_id", using: :btree

  add_foreign_key "blueprints", "eve_items"
  add_foreign_key "caddie_crest_price_history_last_day_timestamps", "eve_items"
  add_foreign_key "caddie_crest_price_history_last_day_timestamps", "regions"
  add_foreign_key "caddie_crest_price_history_updates", "eve_items"
  add_foreign_key "caddie_crest_price_history_updates", "regions"
  add_foreign_key "caddie_price_advices", "eve_items"
  add_foreign_key "caddie_price_advices", "regions"
  add_foreign_key "caddie_price_advices", "trade_hubs"
  add_foreign_key "crest_price_histories", "eve_items"
  add_foreign_key "crest_price_histories", "regions"
  add_foreign_key "crest_prices_last_month_averages", "eve_items"
  add_foreign_key "crest_prices_last_month_averages", "regions"
  add_foreign_key "trade_hubs", "regions"
end
