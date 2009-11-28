Given /^I have no weaving types$/ do
  WeavingType.delete_all
end

Then /^I should have ([0-9]+) weaving types?$/ do |count|
  WeavingType.count.should == count.to_i
end