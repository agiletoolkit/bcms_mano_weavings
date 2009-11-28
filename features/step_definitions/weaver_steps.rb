Given /^I have weavers named (.+)$/ do |names|
  names.split(', ').each do |name|
    Weaver.create!(:name => name)
  end
end

Given /^I have no weavers$/ do
  Weaver.delete_all
end

Then /^I should have ([0-9]+) weaver$/ do |count|
  Weaver.count.should == count.to_i
end