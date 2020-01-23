class AddTimeout < ActiveRecord::Migration[5.2]
  def change
    add_column :sync_logs, :time_out_at, :datetime
  end
end
