Given /^I am logged in as "([^\"]*)" with password "([^\"]*)"$/ do |username, password|
  visit 'cms/login'
  fill_in "login", :with => username
  fill_in "password", :with => password
  click_button "LOGIN"
end