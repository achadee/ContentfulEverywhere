class SyncContentJob < ApplicationJob
  queue_as :syncs

  def perform(last_sync_id)

    sync_log = SyncLog.create(status: SyncLog::STARTING)

    # run the sync log with the last sync_id
    #
    sync_log.run last_sync_id
  end
end
