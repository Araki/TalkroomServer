class AddAllToLists < ActiveRecord::Migration
  def change
    add_column :lists, :channel, :string
    add_column :lists, :fb_uid, :string
    add_column :lists, :fb_name, :string
    add_column :lists, :nickname, :string
    add_column :lists, :email, :string
    add_column :lists, :age, :integer
    add_column :lists, :purpose, :integer
    add_column :lists, :area, :integer
    add_column :lists, :profile_image1, :string
    add_column :lists, :profile_image2, :string
    add_column :lists, :profile_image3, :string
    add_column :lists, :profile, :string
    add_column :lists, :tall, :integer
    add_column :lists, :blood, :integer
    add_column :lists, :style, :integer
    add_column :lists, :holiday, :integer
    add_column :lists, :alcohol, :integer
    add_column :lists, :cigarette, :integer
    add_column :lists, :salary, :integer
    add_column :lists, :point, :integer
  end
end
