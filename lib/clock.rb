require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler do |job|

  # Get the last sync
  last_sync = SyncLog.last

  # grab the sync_id
  #
  sync_id = last_sync.id if last_sync && last_sync.finished?

  # run the job on a delayed job queue
  #
  # we do this because if there is alot of data between offline downtimes the sync
  # might take longer than the interval frequency
  #
  SyncContentJob.perform_later sync_id
end

# jobs
#
every(10.seconds, 'sync.content')
