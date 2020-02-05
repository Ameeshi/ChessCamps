Feature: Manage camps
  As an administrator
  I want to be able to manage camps information
  So I can have camps students can register for

  Background:
    Given an initial setup
  
  # READ METHODS
  Scenario: No camps yet
    Given no setup yet
    When I go to the camps page
    Then I should see "There are no camps in the system at this time"
    And I should not see "Name"
    And I should not see "Start Date"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View all camps
    When I go to the camps page
    Then I should see "Camps"
    And I should see "Name"
    And I should see "Start"
    And I should see "Time"
    And I should see "Max Students"
    And I should see "Endgame Principles"
    And I should see "Mastering Chess Tactics"
    And I should see "07/16/18"
    And I should see "07/23/18"
    And I should see "Afternoon"
    And I should see "8"
    And I should not see "Show"
    And I should not see "Destroy"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    And I should not see "2018-07-16"
    And I should not see "2018-07-23"
  
  Scenario: The camp name is a link to camp details
    When I go to the camps page
    And I click on the link "Endgame Principles"
    And I should see "Endgame Principles"
    And I should see "$150.00"
    And I should see "07/23/18 - 07/27/18"
    And I should see "Camp Instructors"
    And I should see "Mark Heimann"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View camp details
    When I go to the details on Mastering Chess Tactics
    Then I should see "Camp Details"
    And I should see "Mastering Chess Tactics"
    And I should see "This camp is designed for any student who has mastered basic mating patterns and understands opening principles and is looking to improve his/her ability use chess tactics in game situations."
    And I should see "Location: Carnegie Mellon"
    And I should see "07/16/18 - 07/20/18"
    And I should see "Morning"
    And I should see "Active"
    And I should see "Camp Instructors"
    And I should see "Alex Heimann"
    And I should see "Mark Heimann"
    And I should not see "Becca Kern"
    And I should not see "Endgame Principles"
    And I should not see "Jordan Stapinski"
    And I should not see "2018-07-20"
    And I should not see "true"
    And I should not see "True"
  
  # CREATE METHODS
  Scenario: Creating a new camp is successful
    When I go to the new camp page
    And I select "North Side" from "camp_location_id"
    And I select "Endgame Principles" from "camp_curriculum_id"
    And I fill in "camp_cost" with "175"
    And I fill in "camp_max_students" with "8"
    And I fill in "camp_start_date" with "1 September, 2020"
    And I fill in "camp_end_date" with "5 September, 2020"
	And I select "Morning" from "camp_time_slot"
    And I press "Create Camp"
    Then I should see "Camp Details"
    And I should see "Endgame Principles"
    And I should see "$175.00"
    And I should see "09/01/20 - 09/05/20"
    And I should see "No instructors at this time"

  Scenario: Creating a new camp fails without a curriculum
    When I go to the new camp page
    And I fill in "camp_cost" with "175"
    And I fill in "camp_max_students" with "8"
    And I fill in "camp_start_date" with "1 September, 2018"
    And I fill in "camp_end_date" with "5 September, 2018"
    And I select "Morning" from "camp_time_slot"
    And I press "Create Camp"
    Then I should see "can't be blank"


  # UPDATE METHODS
  Scenario: Editing an existing camp is successful
    When I go to the edit camp1's page
    Then I should not see "Remaining Slots"
    And I fill in "camp_cost" with "185"
    And I press "Update Camp"
    Then I should see "$185.00"

