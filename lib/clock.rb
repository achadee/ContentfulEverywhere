require 'clockwork'
require './config/boot'
require './config/environment'

include Clockwork

handler do |job|

  # Get the last sucessful sync
  last_sync = SyncLog.where.not(delta_token: nil).last

  # grab the sync_id
  #
  sync_id = last_sync.id if last_sync

  # run the job on a delayed job queue
  #
  # we do this because if there is alot of data between offline downtimes the sync
  # might take longer than the interval frequency
  #
  SyncContentJob.perform_later sync_id if !sync_id || last_sync.finished?
end

# jobs
#
every(1.minute, 'sync.content')
