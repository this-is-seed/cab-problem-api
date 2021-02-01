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

ActiveRecord::Schema.define(version: 2021_01_29_150809) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cab_trips", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "driver_id"
    t.integer "ride_number"
    t.float "distance_travelled"
    t.boolean "is_cancelled_before_start", default: false
    t.boolean "is_cancelled_after_start", default: false
    t.boolean "is_completed", default: false
    t.float "rating"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "waiting_time"
    t.float "rate_per_km"
    t.float "surge_amount"
    t.string "status"
    t.float "total_fair"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_cab_trips_on_customer_id"
    t.index ["driver_id"], name: "index_cab_trips_on_driver_id"
    t.index ["is_cancelled_after_start"], name: "index_cab_trips_on_is_cancelled_after_start"
    t.index ["is_cancelled_before_start"], name: "index_cab_trips_on_is_cancelled_before_start"
    t.index ["is_completed"], name: "index_cab_trips_on_is_completed"
    t.index ["ride_number"], name: "index_cab_trips_on_ride_number"
  end

  create_table "customer_plans", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.float "rating_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_customer_plans_on_code"
  end

  create_table "customers", force: :cascade do |t|
    t.string "full_name"
    t.string "mobile_number"
    t.bigint "customer_plan_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_plan_id"], name: "index_customers_on_customer_plan_id"
    t.index ["mobile_number"], name: "index_customers_on_mobile_number"
  end

  create_table "drivers", force: :cascade do |t|
    t.string "full_name"
    t.string "mobile_number"
    t.float "rating", default: 5.0
    t.boolean "is_active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_active"], name: "index_drivers_on_is_active"
    t.index ["mobile_number"], name: "index_drivers_on_mobile_number"
  end

end
