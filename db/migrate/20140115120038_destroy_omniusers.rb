class DestroyOmniusers < ActiveRecord::Migration
  def up
    drop_table :omniusers
  end

  def down
  end
end
