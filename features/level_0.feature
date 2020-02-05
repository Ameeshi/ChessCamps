Feature: Standard Business
  As a user
  I want to be able to view certain information
  So I can have basic confidence in the system
  
  Background:

  Scenario: Do not see the default rails page
    When I go to the home page
    Then I should not see "You're riding Ruby on Rails!"
    And I should not see "About your application's environment"
    And I should not see "Create your database" 

  Scenario: View 'About the Chess Camp'
    When I go to the About Us page
    Then I should see "About" within "#footer"
    And I should not see "Lorem"
    And I should not see "lorem"
    And I should not see "ipsum"

  Scenario: View 'Contact Us'
    When I go to the Contact Us page
    Then I should see "Contact" within "#footer"
    And I should not see "Lorem"
    And I should not see "lorem"
    And I should not see "ipsum"

  Scenario: View 'Privacy Policy'
    When I go to the Privacy page
    Then I should see "Privacy" within "#footer"
    And I should not see "Lorem"
    And I should not see "lorem"
    And I should not see "ipsum"

  Scenario: View webmaster information in footer
    When I go to the home page
    Then I should see "Webmaster" within "#footer"
    And I should not see "Lorem"
    And I should not see "lorem"
    And I should not see "ipsum"
  
  Scenario: Navigation exists to link resources
    Given an initial setup
    When I go to the home page
    And I click on the link "Curriculums"
    Then I should see "Smith-Morra Gambit"
    And I should see "400 - 850"
    And I click on the link "Camps"
    Then I should see "Endgame Principles"
    And I should see "Afternoon"
    And I click on the link "Instructors"
    Then I should see "Heimann, Alex"
    And I should see "Bohn, Austin"
    And I click on the link "Locations"
    Then I should see "Carnegie Mellon"
	  And I should see "North Side"
