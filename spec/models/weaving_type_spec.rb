require "spec"

describe "Weaving Type" do

  it "should have a unique name" do
    # Weaving Type should not be valid without a name
    weaving_type = WeavingType.new
    weaving_type.should_not be_valid

    # Weaving Type should be valid once named
    weaving_type.name = 'Shawl'
    weaving_type.should be_valid
    weaving_type.save

    # A Weaving Type with the same name should not be valid
    weaving_type = WeavingType.new :name => 'Shawl'
    weaving_type.should_not be_valid

    # When the name is changed it should be valid
    weaving_type.name = 'Rug'
    weaving_type.should be_valid
  end
end
