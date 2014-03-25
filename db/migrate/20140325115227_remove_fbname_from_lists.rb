class RemoveFbnameFromLists < ActiveRecord::Migration
  def up
    remove_column :lists, :fb_name
  end

  def down
    add_column :lists, :fb_name, :string
  end
end
