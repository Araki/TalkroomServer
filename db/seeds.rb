# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require "csv"

open("db/list.csv") do |file|
  while l = file.gets
    array = l.split("\r")
    array.each do |a|
      row = a.split(",")
      p row
      List.create(
        :channel => row[0],
        :fb_uid => row[1],
        :fb_name => row[2],
        :nickname => row[3],
        :email => row[4],
        :age => row[5],
        :purpose => row[6],
        :area => row[7],
        :profile_image1 => row[8],
        :profile_image2 => row[9],
        :profile_image3 => row[10],
        :profile => row[11],
        :tall => row[12],
        :blood => row[13],
        :style => row[14],
        :holiday => row[15],
        :alcohol => row[16],
        :cigarette => row[17],
        :salary => row[18],
        :point => row[19]
      )
    end  
  end
end
=begin
CSV.foreach('db/list.csv') do |row|
  List.create(:channel => row[0],
              :fb_uid => row[1],
              :fb_name => row[2],
              :nickname => row[3],
              :email => row[4],
              :age => row[5],
              :purpose => row[6],
              :area => row[7],
              :profile_image1 => row[8],
              :profile_image2 => row[9],
              :profile_image3 => row[10],
              :profile => row[11],
              :tall => row[12],
              :blood => row[13],
              :style => row[14],
              :holiday => row[15],
              :alcohol => row[16],
              :cigarette => row[17],
              :salary => row[18],
              :point => row[19])
end
=end
open("db/message.csv") do |file|
  while l = file.gets
    array = l.split("\r")
    array.each do |a|
      row = a.split(",")
      p row
      Message.create(
        :sendfrom_list_id => row[0],
        :sendto_list_id => row[1],
        :room_id => row[2],
        :body => row[3]
      )
    end  
  end
end
=begin
CSV.foreach('db/message.csv') do |row|
  Message.create(:sendfrom_list_id => row[0],
                 :sendto_list_id => row[1],
                 :room_id => row[2],
                 :body => row[3])
end
=end
open("db/room.csv") do |file|
  while l = file.gets
    array = l.split("\r")
    array.each do |a|
      row = a.split(",")
      p row
      Room.create(
        :message_number => row[0],
        :public => row[1]
      )
    end  
  end
end
=begin
CSV.foreach('db/room.csv') do |row|
  Room.create(:public => row[1],
              :message_number => row[0])
end
=end
open("db/visit.csv") do |file|
  while l = file.gets
    array = l.split("\r")
    array.each do |a|
      row = a.split(",")
      p row
      Visit.create(
        :visitor_list_id => row[0],
        :visitat_list_id => row[1]
      )
    end  
  end
end
=begin
CSV.foreach('db/visit.csv') do |row|
  Visit.create(:visitor => row[0],
               :visit_at => row[1])
end
=end