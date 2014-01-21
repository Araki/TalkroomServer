class AddColumnLists < ActiveRecord::Migration
  def up
    add_column :lists, :last_logined, :datetime
  end

  def down
  end
end
