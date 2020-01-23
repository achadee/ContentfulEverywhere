class SyncLog < ApplicationRecord
  STARTING = 0
  IN_PROGRESS = 1
  COMPLETED = 2
  FAILED = 3

  # chech if the sync has finished
  #
  def finished?
    [COMPLETED, FAILED].include? self.status
  end

  def starting?
    self.status == STARTING
  end

  # processes the sync and pull information if required
  #
  def run last_sync_id=nil
    raise Exceptions::SyncAlreadyStartedException if !self.starting?
    # get the sync response
    last_sync_id.nil? ? sync = client.sync(initial: true, type: 'Entry') : sync = client.sync(SyncLog.find(last_sync_id).contentful_cdn_uri)

    #
    # run a recursive function to process the results
    #
    process_response sync
  end

  private
    # Retrieve the client for the contentful library
    #
    def client
      Contentful::Client.new(access_token: ENV['CONTENTFUL_ACCESS_TOKEN'], space: ENV['CONTENTFUL_SPACE_ID'])
    end

    def contentful_cdn_uri
      "https://cdn.contentful.com/spaces/#{ENV['CONTENTFUL_SPACE_ID']}/sync?sync_token=#{self.token}&type=Entry"
    end

    def process_response sync
      # process all the items on this sync
      #
      sync.each_item do |resource|
        Entry.create_from_contentful_item resource
      end
    end
end
