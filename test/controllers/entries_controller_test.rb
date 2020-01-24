require 'test_helper'

class EntriesControllerTest < ActionDispatch::IntegrationTest
  test "get entries" do
    get '/entries'
    assert_response :success
  end

  test "delete entries" do
    post '/delete_data'
    log_count = SyncLog.count
    entry_count = Entry.count
    assert_response(302)
    assert_equal log_count, 0
    assert_equal entry_count, 0
  end

  test "manually sync" do
    post '/entries'
    assert_response(302)
  end
end
