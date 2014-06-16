class AddIndexTransactionIdToIosTransactions < ActiveRecord::Migration
  def change
    add_index :ios_transactions, [:transaction_id], :unique => true
  end
end
