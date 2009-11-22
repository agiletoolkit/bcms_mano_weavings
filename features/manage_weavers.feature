Feature: Manage Weavers
	In order to sell weavings
	As a weaving administrator
	I Want to manage weavers
	
	Scenario: Weavers List
		Given I have weavers named Joe and Jane
		And I am logged in as "cmsadmin" with password "cmsadmin"
		When I go to the list of weavers
		Then I should see "Joe"
		And I should see "Jane"