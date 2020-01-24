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
end
