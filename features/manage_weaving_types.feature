Feature: Manage Weaving Types
	In order to record information about weavings
	As a weaving administrator
	I Want to manage weaving types

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