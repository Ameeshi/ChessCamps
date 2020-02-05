## 67-272: Chess Camp Solution to Phase 4 ##

This is a basic solution for the course project in 67-272: Application Design and Development.  This repo contains a solution only to Phase 4 of the project and can be used to start phase 5.

To set this up, clone this repository, run the `bundle install` command to ensure you have all the needed gems and then create the database with `rake db:migrate`.  If you want to populate the system with fictitious, but somewhat realistic data (similar to the data given in the spreadsheets in phase 1), you can run the `rake db:populate` command.  The populate script will create a series of curriculums, instructors and over 35 camps

Many objects are created with some element of randomness so you will get slightly different results each time it is run.  However, instructors and users are fixed.  If there were any users in this phase, all the users in the system have a password of 'secret'.  In terms of users there are two admins (Alex and Mark) and five instructor-level users (our five Head TAs).  The username for each will be their first name in all lowercase.

Instructions for what needs to be done in this phase of the project can be found in the project write-ups found on the [67-272 course site](http://67272.cmuis.net/projects/).