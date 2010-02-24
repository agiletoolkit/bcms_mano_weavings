Given /^I have no wool types$/ do
  WoolType.delete_all
end

Given /^I have wool types named (.+)$/ do |names|
  names.split(' and ').each do |name|
    Factory(:wool_type, :name => name)
  end
end

Then /^I should have ([0-9]+) wool types?$/ do |count|
  WoolType.count.should == count.to_i
end