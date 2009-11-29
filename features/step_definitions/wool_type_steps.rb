Given /^I have no wool types$/ do
  WoolType.delete_all
end

Then /^I should have ([0-9]+) wool types?$/ do |count|
  WoolType.count.should == count.to_i
end