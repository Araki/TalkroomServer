class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :list_id
      t.integer :fb_uid
      t.string :fb_gender

      t.timestamps
    end
  end
end
