Feature: Manage Weaving Types
	In order to record information about weavings
	As a weaving administrator
	I Want to create new weaving types, edit existing weaving types, delete weaving types and view all weaving types

	Background:
		Given I am logged in as "cmsadmin" with password "cmsadmin"

	Scenario: Create Weaving Type
	    Given I have no weaving types
	    And I am on the list of weaving types
	    When I follow "ADD NEW CONTENT"
	    And I fill in "Name" with "Shawl"
	    And I fill in "Spanish Name" with "Chalina"
	    And I fill in "Low Stock Level" with "5"
	    And I fill in "Description" with "Awesome quality."
	    And I press "weaving_type_submit"
	    Then I should see "Weaving Type 'Shawl' was created"
	    And I should see "Shawl"
	    And I should see "Chalina"
	    And I should see "5"
	    And I should see "Awesome quality."
	    And I should have 1 weaving type

	Scenario: Show only users belonging a group of type "CMS User" in the Primary Stock User listbox
		Given the following user records
			| first_name | groups                                     |
			| No Group   |                                            |
			| Guest      | Guest                                      |
			| Admin User | Cms Administrators                         |
			| Editor     | Content Editors                            |
			| All Groups | Guest, Cms Administrators, Content Editors |
		And I am on the list of weaving types
		When I follow "ADD NEW CONTENT"
		Then I should not see "No Group" within "#weaving_type_user_id"
		And I should not see "Guest" within "#weaving_type_user_id"
		And I should see "Admin User" within "#weaving_type_user_id"
		And I should see "Editor" within "#weaving_type_user_id"
		And I should see "All Groups" within "#weaving_type_user_id"
