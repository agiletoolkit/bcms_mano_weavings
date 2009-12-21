Feature: Manage Weavers
	In order to sell weavings
	As a weaving administrator
	I Want to manage weavings

	Background:
		Given I am logged in as "cmsadmin" with password "cmsadmin"

	@focus
	Scenario: Create Weaver
	    Given I have no weavers
	    And I have weavers named Billy and Jane
	    And I have weaving types named Shawl and Runner
	    And I have wool types named Sheep and Alpaca
	    And I am on the list of weavings
	    When I follow "ADD NEW CONTENT"
	    And I fill in "Item Number" with "001"
	    And I select "Billy" from "Weaver"
	    And I select "Shawl" from "Weaving type"
	    And I select "Sheep" from "Wool type"
	    And I fill in "Purchase price usd" with "45.12"
	    And I fill in "Purchase price bol" with "94.63"
	    And I fill in "Selling price" with "105.43"
	    And I fill in "Description" with "Really nice weaving."
	    And I press "weaving_submit"
	    Then I should see "Weaving '001' was created"
	    And I should see "001"
	    And I should see "Billy"
	    And I should see "Shawl"
	    And I should see "Sheep"
	    And I should see "45.12"
	    And I should see "94.63"
	    And I should see "105.43"
	    And I should see "Really nice weaving."
	    And I should see "draft"
	    And I should have 1 weaving
