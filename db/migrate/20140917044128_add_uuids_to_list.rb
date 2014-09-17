class AddUuidsToList < ActiveRecord::Migration
  def change
    add_column :lists, :uuid, :string
    add_column :lists, :idfv, :string
    add_column :lists, :idfa, :string
  end
end
