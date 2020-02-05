Feature: Manage locations
  As an administrator
  I want to be able to manage location information
  So I can use this to later to create camps

  Background:
    Given an initial setup
  
  # READ METHODS

  Scenario: No locations yet
    Given no setup yet
    When I go to the locations page
    And I should see "There are no active locations in the system at this time"
    And I should not see "Name"
    And I should not see "Address"
    And I should not see "Capacity"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View all locations
    When I go to the locations page
    Then I should see "Locations"
    And I should see "Name"
    And I should see "Address"
    And I should see "Capacity"
    And I should see "Carnegie Mellon"
    And I should see "5000 Forbes Avenue"
    And I should see "Porter Hall 222"
    And I should see "Pittsburgh, PA 15213"
    And I should see "16"
    And I should see "North Side"
    And I should see "801 Union Place"
    And I should see "Pittsburgh, PA 15212"
    And I should not see "Show"
    And I should not see "Destroy"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"
    And I should not see "latitude"
    And I should not see "Latitude"
    And I should not see "Longitude"
  
  Scenario: The location name is a link to details
    When I go to the locations page
    And I click on the link "North Side"
    Then I should see "North Side"
    And I should see "801 Union Place"
    And I should see "Pittsburgh, PA 15212"
    And I should not see "true"
    And I should not see "True"
    And I should not see "ID"
    And I should not see "_id"
    And I should not see "Created"
    And I should not see "created"

  Scenario: View location details
    When I go to the CMU details page
    Then I should see "Carnegie Mellon"
    And I should see "5000 Forbes Avenue"
    And I should see "Porter Hall 222"
    And I should see "Pittsburgh, PA 15213"
    And I should see "Maximum Capacity"
    And I should see "16"
    And I should see "Upcoming Camps"
    And I should not see "North Side"
    And I should not see "latitude"
    And I should not see "Latitude"
    And I should not see "Longitude"
    And I should not see "true"
    And I should not see "True"

  
  # CREATE METHODS
  Scenario: Creating a new location is successful
    When I go to the new location page
    # Then show me the page
    And I fill in "location_name" with "Shadyside"
    And I fill in "location_street_1" with "400 S. Braddock Avenue"
    And I fill in "location_city" with "Pittsburgh"
    And I select "Pennsylvania" from "location_state"
    And I fill in "location_zip" with "15221"
    And I fill in "location_max_capacity" with "14"
    And I press "Create Location"
    Then I should see "Shadyside"
    And I should see "400 S. Braddock Avenue"
    And I should see "Pittsburgh, PA 15221"
    And I should see "No camps at this time"

Scenario: Creating a new location fails without a zip
    When I go to the new location page
    And I fill in "location_name" with "Shadyside"
    And I fill in "location_street_1" with "400 S. Braddock Avenue"
    And I fill in "location_city" with "Pittsburgh"
    And I select "Pennsylvania" from "location_state"
    And I fill in "location_max_capacity" with "14"
    And I press "Create Location"
    Then I should see "can't be blank"
  
  Scenario: Creating a new location fails without unique name
    When I go to the new location page
    And I fill in "location_name" with "carnegie mellon"
    And I fill in "location_street_1" with "Frew Street"
    And I fill in "location_city" with "Pittsburgh"
    And I select "Pennsylvania" from "location_state"
    And I fill in "location_zip" with "15213"
    And I fill in "location_max_capacity" with "16"
    And I press "Create Location"
    Then I should see "has already been taken"
  
  
  # UPDATE METHODS
  Scenario: Updating an existing location is successful
    When I go to edit the North Side page
    And I fill in "location_street_2" with "3rd Floor"
    And I press "Update Location"
    Then I should see "North Side"
    And I should see "3rd Floor"
