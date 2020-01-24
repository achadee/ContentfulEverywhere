class SyncLog < ApplicationRecord
  STARTING = 0
  IN_PROGRESS = 1
  COMPLETED = 2
  FAILED = 3

  # chech if the sync has finished
  #
  def finished?
    [COMPLETED, FAILED].include?(self.status) || ([STARTING, IN_PROGRESS].include?(self.status) && self.time_out_at < DateTime.now)
  end

  def set_status status
    return false if ![STARTING, IN_PROGRESS, COMPLETED, FAILED].include?(status)
    self.status = status
    self.save
  end

  # processes the sync and pull information if required
  #
  def run last_sync_id=nil
    begin
      # raise Exceptions::SyncStillInProgressException if !self.finished?
      self.set_status(IN_PROGRESS)

      # get the sync response
      last_sync_id.nil? ? sync = client.sync(initial: true, type: 'Entry') : sync = client.sync(SyncLog.find(last_sync_id).delta_token)

      #
      # run a recursive function to process the results
      #
      process_response sync

      # get the token from the response
      self.delta_token = sync.next_sync_url
      self.set_status(COMPLETED)
      return true
    rescue HTTP::ConnectionError => e
      self.set_status(FAILED)
      return false
    end
  end

  private
    # Retrieve the client for the contentful library
    #
    def client
      Contentful::Client.new(access_token: ENV['CONTENTFUL_ACCESS_TOKEN'], space: ENV['CONTENTFUL_SPACE_ID'])
    end

    def process_response sync
      # process all the items on this sync
      # docs say we can access every page using the 'each_item' block
      #
      sync.each_item do |resource|
        Entry.create_from_contentful_item resource
      end
    end
end
