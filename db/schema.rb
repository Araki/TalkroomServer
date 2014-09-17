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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140917044128) do

  create_table "buying_histories", :force => true do |t|
    t.integer  "list_id"
    t.string   "platform"
    t.integer  "transaction_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "ca_rewards", :force => true do |t|
    t.integer  "list_id"
    t.integer  "cid"
    t.string   "cname"
    t.integer  "carrier"
    t.string   "click_date"
    t.string   "action_date"
    t.integer  "commission"
    t.string   "aff_id"
    t.integer  "point"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "pid"
  end

  create_table "friends", :force => true do |t|
    t.integer  "list_id"
    t.integer  "fb_uid"
    t.string   "fb_gender"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "inquiries", :force => true do |t|
    t.integer  "list_id"
    t.string   "platform"
    t.string   "address"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.text     "body"
    t.string   "version"
    t.string   "manufacturer"
    t.string   "model"
  end

  create_table "ios_transactions", :force => true do |t|
    t.string   "purchase_type"
    t.string   "product_id"
    t.string   "transaction_id"
    t.datetime "purchase_date"
    t.string   "bvrs"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "ios_transactions", ["transaction_id"], :name => "index_ios_transactions_on_transaction_id", :unique => true

  create_table "lists", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "channel"
    t.string   "fb_uid"
    t.string   "nickname"
    t.string   "email"
    t.integer  "age"
    t.integer  "purpose"
    t.integer  "area"
    t.string   "profile_image1"
    t.string   "profile_image2"
    t.string   "profile_image3"
    t.string   "profile"
    t.integer  "tall"
    t.integer  "blood"
    t.integer  "style"
    t.integer  "holiday"
    t.integer  "alcohol"
    t.integer  "cigarette"
    t.integer  "salary"
    t.integer  "point"
    t.datetime "last_logined"
    t.string   "gender"
    t.string   "app_token"
    t.string   "uuid"
    t.string   "idfv"
    t.string   "idfa"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sendfrom_list_id"
    t.integer  "sendto_list_id"
    t.integer  "room_id"
    t.string   "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "point_consumptions", :force => true do |t|
    t.integer  "list_id"
    t.string   "item_type"
    t.integer  "point_consumption"
    t.integer  "room_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "rooms", :force => true do |t|
    t.boolean  "public"
    t.integer  "message_number"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.integer  "male_last_message"
    t.integer  "female_last_message"
    t.integer  "male_id"
    t.integer  "female_id"
  end

  create_table "visits", :force => true do |t|
    t.integer  "visitor_list_id"
    t.integer  "visitat_list_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
