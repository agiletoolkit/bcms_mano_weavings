require File.join(File.dirname(__FILE__), '/../../test_helper')

class WeavingPhotoTest < ActiveSupport::TestCase

  test "should be able to create new block" do
    assert WeavingPhoto.create!
  end

end