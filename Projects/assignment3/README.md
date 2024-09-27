## Submission: Step 1 of 2

## Project Name

assignment3 - Match 3

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. In PlayState, where the score is calculated for matches, I added a line to increment the timer by the number of matches.
2. In PlayState and BeginGameState, any time the Board class is called a new argument of level must be added. This change also must be reflected in the Board class itself. In BeginGameState, the self.board definition needs to be moved to BeginGameState:enter so that it can access self.level as an argument. Add logic to tile generation so that the possible varieties are tied to the current level. I've created a helper function so that possible varieties are added to a table in such a way that lower varieties are prioritized (harder to get higher variety tiles on the board). Use this in getFallingTiles and initializeTiles functions in Board.lua. Update the scoring function in PlayState so that the higher varieties add a multiplier to score calculation.
3. In the Board.lua tile generation section, add logic to allow for random tiles to be shiny and pass this into the tile class (a shiny argument is added)(for both new boards and new falling tiles). When matches are calculated, check if shiny tile is there, and add the whole row to the match. Generate a particle system for shiny tiles - update functions need to get passed through from PlayState to Board to Tile.
4.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
