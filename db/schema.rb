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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140115111942) do

  create_table "lists", :force => true do |t|
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "channel"
    t.string   "fb_uid"
    t.string   "fb_name"
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
  end

  create_table "omniusers", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "image"
    t.string   "email"
  end

end
