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

ActiveRecord::Schema.define(version: 20161221145306) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orders", force: :cascade do |t|
    t.integer "person_id", null: false
  end

  add_index "orders", ["person_id"], name: "index_orders_on_person_id", using: :btree

  create_table "orders_products", force: :cascade do |t|
    t.integer "order_id",   null: false
    t.integer "product_id", null: false
  end

  add_index "orders_products", ["order_id"], name: "index_orders_products_on_order_id", using: :btree
  add_index "orders_products", ["product_id"], name: "index_orders_products_on_product_id", using: :btree

  create_table "people", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
  end

  create_table "products", force: :cascade do |t|
    t.string  "name"
    t.decimal "price",       precision: 8, scale: 2
    t.string  "asin"
    t.string  "color"
    t.string  "department"
    t.text    "description"
  end

  add_foreign_key "orders", "people"
  add_foreign_key "orders_products", "orders"
  add_foreign_key "orders_products", "products"
end
