## Submission: Step 1 of 2

## Project Name

Assignment6 - Angry Birds

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Change userData for all fixtures in the game such that userData consists of a table instead of a single string, add a "collided" flag to the table. Update collision logic such that player fixture collision flag updates after the collision. In AlienLaunchMarker, self.alien must become the empty table self.aliens, into which newly spawned aliens will be placed. Add logic such that after the alien has been launched, new aliens will spawn if spacebar is pressed and not collided with anything yet (set a flag also for spacebar being pressed that prevents users from splitting the alien more than once). Update logic for re-spawning launchMarker so that it waits for all aliens to stop in level:update - I found it best to separate the offscreen and stopped-moving logic - if one alien goes offscreen, we can re-spawn, but wait till all aliens stop to do so. I also decided to place a vertical wall offscreen to the right to stop aliens from rolling too far in Level.lua, so that users don't have to wait too long for the launch to respawn.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[X] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
