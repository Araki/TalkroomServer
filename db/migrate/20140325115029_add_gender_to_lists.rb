class AddGenderToLists < ActiveRecord::Migration
  def change
    add_column :lists, :gender, :string
  end
end
