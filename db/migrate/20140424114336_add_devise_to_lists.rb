class AddDeviseToLists < ActiveRecord::Migration
  def self.up
    #change_table(:lists) do |t|
      ## Database authenticatable
      #t.string :email,              :null => false, :default => ""
      #t.string :encrypted_password, :null => false, :default => ""

      ## Recoverable
      #t.string   :reset_password_token
      #t.datetime :reset_password_sent_at

      ## Rememberable
      #t.datetime :remember_created_at

      ## Trackable
      #t.integer  :sign_in_count, :default => 0
      add_column :lists, :sign_in_count, :integer, :default => 0
      #t.datetime :current_sign_in_at
      add_column :lists, :current_sign_in_at, :datetime
      #t.datetime :last_sign_in_at
      add_column :lists, :last_sign_in_at, :datetime      
      #t.string   :current_sign_in_ip
      add_column :lists, :current_sign_in_ip, :string
      #t.string   :last_sign_in_ip
      add_column :lists, :last_sign_in_ip, :string
      
      ##Omniauthable
      #t.integer :uid, :limit => 8 #bigintにする
      add_column :lists, :uid, :integer, :limit => 8
      #t.string :name
      #t.string :provider
      #t.string :password
      add_column :lists, :password, :string

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      # Uncomment below if timestamps were not included in your original model.
      # t.timestamps
    #end

    #add_index :lists, :email,                unique: true
    #add_index :lists, :reset_password_token, unique: true
    # add_index :lists, :confirmation_token,   unique: true
    # add_index :lists, :unlock_token,         unique: true
  end

  def self.down
    # By default, we don't want to make any assumption about how to roll back a migration when your
    # model already existed. Please edit below which fields you would like to remove in this migration.
    raise ActiveRecord::IrreversibleMigration
  end
end
