## Submission: Step 1 of 2

## Project Name

Assignment4 - Super Mario Bros

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. In PlayState, replace the players starting X value with a variable. Prior to that initiate the variable and create logic to check for ground tiles: iterate over the columns of tiles checking for the ground tile id, if there is one, update the x value to whichever is the current column and break out of the loop. Convert the x value to a column value so the player lands squarely on a tile.
2. In Levelmaker, create flags for lock and key generation. Create a flag is the key has been obtained. Add sprite sheet frames and textures to dependencies, use logic in frames so that keys access the first half of sheet and locks access second. Create logic for key generation in Levelmaker so they can spawn on a pillar or on the ground. Create logic for lock creation, borrowing heavily from jump box logic, adjust the onCollide function so that if the key is obtained the object will be removed from the table.
3. Add flag dependencies for quad generation in dependecies.lua. Adjust GameObject class to be able to draw the irregularly shaped flag pole. Add to the onCollide function for the lock box in Levelmaker.lua so that a new flag pole is generated when player collides with lock box. This has been added as a separate function at bottom of LevelMaker to help readability. Function checks to make sure where ground is and make sure not to load flag in a chasm. Create a table for whitelisted flag types so that the built in game object renderer can be used (since flags are 16x16)
4. Adjust the onConsume function for the flag pole in LevelMaker so that it will generate a new level and pass in paramters of score and width (with a width multiplier to increase size every time activated). Adjust the StartState to match parameters to be passed in. I've created a constant for initial starting width so it can be accessed by both Play and Start states and I can change it easily (I've been making levels really short for testing purposes). Move level generation and chasm-check for player out of init and into enter function so all logic has access to necessary variables. Add logic to PlayState:enter for calculating score for player, if entering from start state it will be 0, if entering from play state, it will be whatever the current score is. 

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
