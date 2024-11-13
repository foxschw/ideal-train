## Submission: Step 1 of 2

## Project Name

assignment 7 - Pokemon

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Create a LevelUpMenuState, add it to dependencies. When self.playerPokemon:levelUp() is called, store the return values into variables. In TakeTurnState.lua, push LevelUpMenuState 1.5 seconds after the 'Congrats, Level Up' message is displayed in the victory portion of the code. Pass in the increase values returned by levelup() to the push call. In LevelUpMenuState, derive the original stats (the ones the pokemon had before leveling up) by subtracting the increase from the current amount and store as variables. In the items table that will eventually get passed to Selection.lua, arrange the text appropriately such that it is displayed according to the spec. Add a leaveMenu function that is used for onSelect on all parameters that will exit the battlestate appropriately.
In the MenuState/Menu/Selection pathway, include a 'type' parameter. I used 'display' for LevelUpMenuState and 'choice' for BattleMenuState. Use this parameter to define logic that will control cursor behavior. For 'choice' the behavior remains as it always has, for 'display,' the cursor is not rendered, but if the user presses enter or space, the onSelect function will still be called, triggering the transition. I also found that I needed to reduce the gapHeight for the LevelUpMenu, so I used conditions for type to make that adjustment without affecting the BattleMenuState.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[X] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
