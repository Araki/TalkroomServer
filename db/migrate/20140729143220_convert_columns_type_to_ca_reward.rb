class ConvertColumnsTypeToCaReward < ActiveRecord::Migration
  def up
    change_column :ca_rewards, :click_date, :string
    change_column :ca_rewards, :action_date, :string
  end

  def down
  end
end
