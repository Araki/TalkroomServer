class CreateInquiries < ActiveRecord::Migration
  def change
    create_table :inquiries do |t|
      t.integer :list_id
      t.string :platform
      t.string :address
      t.text :body

      t.timestamps
    end
  end
end
