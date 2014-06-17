class RenameColumnIosTransactions < ActiveRecord::Migration
  def up
    rename_column :ios_transactions, :type, :purchase_type
  end

  def down
    rename_column :ios_transactions, :purchase_type, :type
  end
end
