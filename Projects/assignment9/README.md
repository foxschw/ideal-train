## Submission: Step 1 of 2

## Project Name

Assignment9 - DreadHalls

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Create public variables in LevelGenerator for max amount of holes per level, the probability for hole creation, and a counter for holes created. The counter could be private, but it's nice to have a quick way to make sure your probability is working out as you want. The other ones are good for tweaking the adjustments. Create an if condition around the code that creates the floor tiles. If we're in a hall (mapData x and y are false) and we haven't exceeded our max hole count and we're within the probability, don't create the floor, just increment the hole counter. Otherwise create the floor as usual.
2. Copy the Title Scene and format it for Game Over. Add the scene to the Build Settings. Adjust the LoadSceneOnInput script such that it checks which scene is active and routes accordingly (to play if current scene is title, and to title if current scene is game over). Write the DespawnOnHeight script and add it to FPS Controller. 

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
