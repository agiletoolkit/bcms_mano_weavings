Feature: Manage Weavers
	In order to sell weavings
	As a weaving administrator
	I Want to manage weavers

	Background:
		Given I am logged in as "cmsadmin" with password "cmsadmin"

	Scenario: Weavers List
		Given I have weavers named Joe and Jane
		When I go to the list of weavers
		Then I should see "Joe"
		And I should see "Jane"

	Scenario: Create Weaver
	    Given I have no weavers
	    And I am on the list of weavers
	    When I follow "ADD NEW CONTENT"
	    And I fill in "Name" with "Joe"
	    And I fill in "Last Name" with "Bloggs"
	    And I fill in "Description" with "The unknown weaver."
	    And I press "weaver_submit"
	    Then I should see "Weaver 'Joe' was created"
	    And I should see "Joe"
	    And I should see "Bloggs"
	    And I should see "The unknown weaver."
	    And I should see "draft"
	    And I should have 1 weaver
