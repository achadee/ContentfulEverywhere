require 'test_helper'

class SyncContentJobTest < ActiveJob::TestCase
  test "Create new sync log" do
    sj = SyncContentJob.new
    result = sj.perform nil
    assert result.is_a?(SyncLog)
  end
end
