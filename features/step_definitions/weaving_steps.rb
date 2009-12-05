Then /^I should have ([0-9]+) weavings?$/ do |count|
  Weaving.count.should == count.to_i
end