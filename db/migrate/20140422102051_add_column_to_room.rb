class AddColumnToRoom < ActiveRecord::Migration
  def change
    add_column :rooms, :male_last_message, :integer
    add_column :rooms, :female_last_message, :integer
  end
end
