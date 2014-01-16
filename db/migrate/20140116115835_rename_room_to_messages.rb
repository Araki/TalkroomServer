class RenameRoomToMessages < ActiveRecord::Migration
  def up
    rename_column :messages, :send_from, :sendfrom_list_id
    rename_column :messages, :send_to, :sendto_list_id
    rename_column :messages, :room, :room_id
    rename_column :visits, :visitor, :visitor_list_id
    rename_column :visits, :visit_at, :visitat_list_id
  end

  def down
  end
end
