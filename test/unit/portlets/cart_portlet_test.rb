require File.join(File.dirname(__FILE__), '/../../test_helper')

class CartTest < ActiveSupport::TestCase

  test "Should be able to create new instance of a portlet" do
    assert CartPortlet.create!(:name => "New Portlet")
  end

end
