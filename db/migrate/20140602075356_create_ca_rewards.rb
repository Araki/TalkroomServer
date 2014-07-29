class CreateCaRewards < ActiveRecord::Migration
  def change
    create_table :ca_rewards do |t|
      t.integer :id
      t.integer :list_id
      t.integer :cid
      t.string :cname
      t.integer :carrier
      t.integer :click_date
      t.integer :action_date
      t.integer :commission
      t.string :aff_id
      t.integer :point
      t.integer :pid

      t.timestamps
    end
  end
end
