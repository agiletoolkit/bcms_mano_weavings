Given /^I have no weaving types$/ do
  WeavingType.delete_all
end

Given /^I have weaving types named (.+)$/ do |names|
  names.split(' and ').each do |name|
    WeavingType.create!(:name => name)
  end
end

Then /^I should have ([0-9]+) weaving types?$/ do |count|
  WeavingType.count.should == count.to_i
end