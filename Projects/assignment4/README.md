## Submission: Step 1 of 2

## Project Name

Assignment4 - Super Mario Bros

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. In PlayState, replace the players starting X value with a variable. Prior to that initiate the variable and create logic to check for ground tiles: iterate over the columns of tiles checking for the ground tile id, if there is one, update the x value to whichever is the current column and break out of the loop. Convert the x value to a column value so the player lands squarely on a tile.
2. In Levelmaker, create flags for lock and key generation. Create a flag is the key has been obtained. Add sprite sheet frames and textures to dependencies, use logic in frames so that keys access the first half of sheet and locks access second. Create logic for key generation in Levelmaker so they can spawn on a pillar or on the ground. Create logic for lock creation, borrowing heavily from jump box logic, adjust the onCollide function so that if the key is obtained the object will be removed from the table.
3.
4.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
