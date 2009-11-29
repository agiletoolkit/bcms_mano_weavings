require File.join(File.dirname(__FILE__), '/../../test_helper')

class WoolTypeTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert WoolType.create!
  end
  
end