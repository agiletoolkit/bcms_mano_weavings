require "spec_helper"

describe "Weaving" do

  it "should have an item number which is unique" do
    # Should not be valid without an item number
    weaving = Factory.build(:weaving, :item_number => nil)
    weaving.should_not be_valid

    # Should be valid once an item number is assigned
    weaving.item_number = '100'
    weaving.should be_valid
    weaving.save

    # Should not allow another weaving with the same item number
    weaving = Factory.build(:weaving, :item_number => '100')
    weaving.should_not be_valid

    # A different item number should make the weaving valid
    weaving.item_number = '200'
    weaving.should be_valid
  end

  it "should have a description" do
    # Should not be valid without a description
    weaving = Factory.build(:weaving, :description => nil)
    weaving.should_not be_valid

    # Should be valid once a description is assigned
    weaving.description = 'A really cool weaving.'
    weaving.should be_valid
  end

  it "should have a summary description" do
    # Should not be valid without a summary description
    weaving = Factory.build(:weaving, :summary_description => nil)
    weaving.should_not be_valid

    # Should be valid once a summary description is assigned
    weaving.summary_description = 'Something catchy.'
    weaving.should be_valid
  end

  it "should have a published weaving type" do
    # Should not be valid without weaving type
    weaving = Factory.build(:weaving, :weaving_type => nil)
    weaving.should_not be_valid

    # Should not be valid with an unpublished weaving type
    weaving_type = Factory.build(:weaving_type, :published => false)
    weaving.weaving_type = weaving_type
    weaving.should_not be_valid

    # Should be valid once the weaving type is published
    weaving_type.publish!
    weaving.should be_valid
  end

  it "should have a published weaver" do
    # Should not be valid without weaver
    weaving = Factory.build(:weaving, :weaver => nil)
    weaving.should_not be_valid

    # Should not be valid with an unpublished weaver
    weaver = Factory.build(:weaver, :published => false)
    weaving.weaver = weaver
    weaving.should_not be_valid

    # Should be valid once the weaver is published
    weaver.publish!
    weaving.should be_valid
  end

  it "should have a published wool type" do
    # Should not be valid without wool type
    weaving = Factory.build(:weaving, :wool_type => nil)
    weaving.should_not be_valid

    # Should not be valid with an unpublished wool type
    wool_type = Factory.build(:wool_type, :published => false)
    weaving.wool_type = wool_type
    weaving.should_not be_valid

    # Should be valid once the wool type is published
    wool_type.publish!
    weaving.should be_valid
  end

  it "should search by item number (not name) in content library" do
    # The item_number and name are normally the same as the module only sets item_number
    # (check weaving model for explanation)
    weaving = Factory.build(:weaving)
    weaving.name = 'bar'
    weaving.item_number = 'foo'
    weaving.save

    # When I search for the item_number the weaving should be in the result set
    Weaving.search(:term => 'foo').find_all{|w| w == weaving }.size.should be(1)

    # When I search for the name the weaving should not be in the result set
    Weaving.search(:term => 'bar').find_all{|w| w == weaving }.size.should be(0)
  end
end
