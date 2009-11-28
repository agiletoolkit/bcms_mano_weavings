require File.join(File.dirname(__FILE__), '/../../test_helper')

class WeavingTypeTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert WeavingType.create!
  end
  
end