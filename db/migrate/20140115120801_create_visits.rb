class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visitor
      t.integer :visit_at

      t.timestamps
    end
  end
end
