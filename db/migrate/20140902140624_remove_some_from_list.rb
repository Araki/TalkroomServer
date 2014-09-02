class RemoveSomeFromList < ActiveRecord::Migration
  def up
    remove_column :lists, :sign_in_count
    remove_column :lists, :current_sign_in_at
    remove_column :lists, :last_sign_in_at
    remove_column :lists, :current_sign_in_ip
    remove_column :lists, :last_sign_in_ip
    remove_column :lists, :uid
    remove_column :lists, :password
  end

  def down
    add_column :lists, :password, :string
    add_column :lists, :uid, :integer
    add_column :lists, :last_sign_in_ip, :string
    add_column :lists, :current_sign_in_ip, :string
    add_column :lists, :last_sign_in_at, :datetime
    add_column :lists, :current_sign_in_at, :datetime
    add_column :lists, :sign_in_count, :integer
  end
end
