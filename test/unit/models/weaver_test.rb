require File.join(File.dirname(__FILE__), '/../../test_helper')

class WeaverTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert Weaver.create!
  end
  
end