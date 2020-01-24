require 'test_helper'

class SyncLogTest < ActiveSupport::TestCase
  test "should return finished in finished state" do
    t1 = SyncLog.create(status: SyncLog::COMPLETED)
    t2 = SyncLog.create(status: SyncLog::FAILED)
    t3 = SyncLog.create(status: SyncLog::STARTING, time_out_at: 1.day.ago)
    t4 = SyncLog.create(status: SyncLog::IN_PROGRESS, time_out_at: 1.day.ago)

    assert t1.finished?
    assert t2.finished?
    assert t3.finished?
    assert t4.finished?
  end

  test "should set the status to the assigned status" do
    t1= SyncLog.create(status: SyncLog::STARTING)
    t1.set_status(SyncLog::IN_PROGRESS)
    assert_equal t1.status, SyncLog::IN_PROGRESS
  end

  test "should not set a status that is not defined in the scope of statuses" do
    t1= SyncLog.create(status: SyncLog::STARTING)
    t1.set_status(46)
    assert_not_equal t1.status, 46
  end

  test "should not return nil with running SyncLog" do
    t1= SyncLog.create(status: SyncLog::STARTING)
    assert [true, false].include? t1.run
  end

end
