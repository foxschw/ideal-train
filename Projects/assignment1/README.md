## Submission: Step 1 of 2

## Project Name

Assignment 1 - Fifty Bird

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. In PipePair.lua on line 29, I've added a math.random function to generate a random number that gets added or subtracted from GAP_HEIGHT. Now, GAP_HEIGHT is no longer a hard coded gap between the heights but a baseline height that the random function can add variation to.
2. In states/Playstate.lua in the function PlayState:init(), line 29 I set an intial first interval randomly. This is a float between 0 and 1, scaled by 1.5 and shifted up by 1.2, this yielded a desireable random range. I set the timer to check for that random interval (line 37), then generate a new random interval (using the same initial parameters) after the pipe pair has been generated and the timer reset (line 52).
3. First I collected three medal images for assets and included them in the project folder. I initialze them into variables in the beginning of ScoreState.lua line 29 so that they can be used later. In the ScoreState:render function of the same file I include the logic to display different medals based on scores achieved (line 43). I used elseif conditions to both determine what scores yields what medal and love.graphics.draw to render the images on screen.
4. In main.lua, I initialize an isPaused boolean variable that tracks if the game is paused (line 66). Then I use an if condition to track if the letter P is pressed in the love.keypressed function - if P is pressed the boolean value switches (line 132). In the update function, I encapsulate all the existing logic inside of an if condition (line 166). If the game is not paused, it updates as normal. If it is paused it simply doesn't update, freezing the game in place until P is pressed again.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.