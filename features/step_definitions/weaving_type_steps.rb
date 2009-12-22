Given /^I have no weaving types$/ do
  WeavingType.delete_all
end

Given /^I have weaving types named (.+)$/ do |names|
  names.split(' and ').each do |name|
    WeavingType.create!(:name => name)
  end
end

Given /^the following user records$/ do |table|
  table.hashes.each do |hash|
    current_user = User.create(:login => hash[:first_name].gsub(/\ /, ''), :first_name => hash[:first_name], :last_name => "", :email => "foo@bar.com", :password => "password", :password_confirmation => "password")
    hash[:groups].split(', ').each do |group|
      current_user.groups << Group.find_by_name(group)
    end
  end
end

Then /^I should have ([0-9]+) weaving types?$/ do |count|
  WeavingType.count.should == count.to_i
end