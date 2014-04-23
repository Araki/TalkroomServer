class AddUserColumnsToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :male_id, :integer
    add_column :rooms, :female_id, :integer
  end
end
