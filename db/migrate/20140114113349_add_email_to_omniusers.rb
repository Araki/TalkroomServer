class AddEmailToOmniusers < ActiveRecord::Migration
  def change
    add_column :omniusers, :email, :string
  end
end
