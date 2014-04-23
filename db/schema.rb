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

ActiveRecord::Schema.define(:version => 20140422131235) do

  create_table "friends", :force => true do |t|
    t.integer  "list_id"
    t.integer  "fb_uid"
    t.string   "fb_gender"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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
  end

  create_table "messages", :force => true do |t|
    t.integer  "sendfrom_list_id"
    t.integer  "sendto_list_id"
    t.integer  "room_id"
    t.string   "body"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
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
