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

ActiveRecord::Schema.define(version: 20140820012953) do

  create_table "avatars", force: true do |t|
    t.integer  "user_id",    null: false
    t.string   "image",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "avatars", ["user_id"], name: "index_avatars_on_user_id"

  create_table "baskets", force: true do |t|
    t.integer  "user_id",                    null: false
    t.string   "name",                       null: false
    t.float    "latitude",                   null: false
    t.float    "longitude",                  null: false
    t.integer  "comments_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sector_id"
  end

  add_index "baskets", ["latitude", "longitude"], name: "index_baskets_on_latitude_and_longitude", unique: true
  add_index "baskets", ["latitude"], name: "index_baskets_on_latitude"
  add_index "baskets", ["longitude"], name: "index_baskets_on_longitude"
  add_index "baskets", ["sector_id"], name: "index_baskets_on_sector_id"
  add_index "baskets", ["user_id"], name: "index_baskets_on_user_id"

  create_table "baskets_categories", id: false, force: true do |t|
    t.integer "basket_id",   null: false
    t.integer "category_id", null: false
  end

  add_index "baskets_categories", ["basket_id", "category_id"], name: "index_baskets_categories_on_basket_id_and_category_id", unique: true

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "comments", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "basket_id",  null: false
    t.text     "comment",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["basket_id"], name: "index_comments_on_basket_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "photos", force: true do |t|
    t.integer  "basket_id",  null: false
    t.string   "image",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "photos", ["basket_id"], name: "index_photos_on_basket_id"
  add_index "photos", ["user_id"], name: "index_photos_on_user_id"

  create_table "sectors", force: true do |t|
    t.integer  "baskets_count", default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username",                              null: false
    t.string   "email",                                 null: false
    t.string   "password_digest",                       null: false
    t.boolean  "admin",                 default: false, null: false
    t.integer  "baskets_count",         default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "notifications_enabled", default: true,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
