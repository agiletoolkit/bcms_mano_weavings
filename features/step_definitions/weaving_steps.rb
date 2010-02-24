Given /^I have the following weavings$/ do |table|
  table.hashes.each do |hash|
    Factory(:weaving, :item_number => hash['item number'],
      :weaving_type => WeavingType.find_by_name(hash['type'], :first),
      :published => hash['published'] == 'yes' ? true : false)
  end
end

Then /^I should have ([0-9]+) weavings?$/ do |count|
  Weaving.count.should == count.to_i
end