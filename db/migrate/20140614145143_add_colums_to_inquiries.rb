class AddColumsToInquiries < ActiveRecord::Migration
  def change
    add_column :inquiries, :version, :string
    add_column :inquiries, :manufacturer, :string
    add_column :inquiries, :model, :string
  end
end
