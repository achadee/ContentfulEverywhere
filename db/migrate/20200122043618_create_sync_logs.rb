class CreateSyncLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :sync_logs do |t|
      t.integer :status
      t.string :delta_token
      t.timestamps
    end
  end
end
