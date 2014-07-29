class AddPidToCaReward < ActiveRecord::Migration
  def change
    add_column :ca_rewards, :pid, :integer
  end
end
