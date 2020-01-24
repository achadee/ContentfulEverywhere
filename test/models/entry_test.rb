require 'test_helper'

# to test entries we need a contentful item so lets make one up for now
#
class ContentfulItem
  def initialize(id)
    @id = id
  end

  def id
    @id
  end

  def sys
    {created_at: DateTime.now}
  end

  def raw_with_links
    {data: "some data"}
  end

  def fields
    []
  end
end

class EntryTest < ActiveSupport::TestCase

  test "should create a new entry from a contentful item" do
    c = ContentfulItem.new "sdhjdf"
    entry = Entry.create_from_contentful_item c
    assert entry.is_a?(Entry)
  end

end
