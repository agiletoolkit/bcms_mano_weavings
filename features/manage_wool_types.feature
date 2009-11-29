Feature: Manage Wool Types
	In order to record information about weavings
	As a weavings administrator
	I Want to manage wool types

	Background:
		Given I am logged in as "cmsadmin" with password "cmsadmin"

	Scenario: Create Weaving Type
	    Given I have no wool types
	    And I am on the list of wool types
	    When I follow "ADD NEW CONTENT"
	    And I fill in "Name" with "Sheep"
	    And I fill in "Description" with "Wool from the creatures you count when you can't sleep."
	    And I press "wool_type_submit"
	    Then I should see "Wool Type 'Sheep' was created"
	    And I should see "Sheep"
	    And I should see "Wool from the creatures you count when you can't sleep."
	    And I should have 1 wool type