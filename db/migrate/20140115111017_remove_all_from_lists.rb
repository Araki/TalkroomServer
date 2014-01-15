class RemoveAllFromLists < ActiveRecord::Migration
  def up
    remove_column :lists, :name
    remove_column :lists, :number
  end

  def down
    add_column :lists, :number, :integer
    add_column :lists, :name, :string
  end
end
