class EntriesController < ApplicationController

  #
  # root method for displaying all the data locally
  #
  def index
    params[:page_size].to_i == 0 ? page_size = 100 : page_size = params[:page_size].to_i
    page = params[:page].to_i || 0

    data = Entry.order("created_on_contentful_at desc").offset(page_size*page).limit(page_size).pluck(:data)

    response = {
      sys: {
        type: "Array"
      },
      total: data.count,
      skip: page_size*page,
      limit: page_size,
      items: data
    }
    render json: JSON.pretty_generate(response)
  end


  # not really restful but will act as our sync endpoint to create and update
  # new entries
  #
  def create
    # Get the last sucessful sync
    last_sync = SyncLog.where.not(delta_token: nil).last

    # grab the sync_id
    #
    sync_id = last_sync.id if last_sync

    # this is a manual sync so lets perform it syncronously so there is feedback
    #  for the user
    SyncContentJob.perform_now sync_id if !sync_id || last_sync.finished?
    redirect_to "/entries"
  end

  def destroy
    # clean up the entries and the sync logs
    Entry.destroy_all
    SyncLog.destroy_all

    # redirect to an empty entries page
    redirect_to "/entries"
  end
end
