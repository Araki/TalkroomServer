class AddAppTokenToLists < ActiveRecord::Migration
  def change
    add_column :lists, :app_token, :string
  end
end
