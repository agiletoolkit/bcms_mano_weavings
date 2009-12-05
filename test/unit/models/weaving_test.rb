require File.join(File.dirname(__FILE__), '/../../test_helper')

class WeavingTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert Weaving.create!
  end
  
end