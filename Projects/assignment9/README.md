## Submission: Step 1 of 2

## Project Name

Assignment9 - DreadHalls

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Create public variables in LevelGenerator for max amount of holes per level, the probability for hole creation, and a counter for holes created. The counter could be private, but it's nice to have a quick way to make sure your probability is working out as you want and make changes on the gui. The other ones are good for tweaking the adjustments. Create an if condition around the code that creates the floor tiles. If we're in a hall (mapData x and y are false) and we haven't exceeded our max hole count and we're within the probability, don't create the floor, just increment the hole counter. Otherwise create the floor as usual.
2. Copy the Title Scene and format it for Game Over. Add the scene to the Build Settings. Adjust the LoadSceneOnInput script such that it checks which scene is active and routes accordingly (to play if current scene is title, and to title if current scene is game over). In the Game Over scene, it will route to Title and destroy the WhisperSource game object to prevent the singleton from overlapping later. Write the DespawnOnHeight script and add it to FPS Controller. 
3. Add a Text UI component to play scene and place it appropriately on the 2D canvas. In grab pickups, create public static int currentLevel that initializes to 1 and increments by 1 every time a coin is picked up. Create script CurrentLevelText that creates the text content dynamically based on the currentLevel variable. Make sure level number is reset to 1 after Game Over. I did this in the Load Scene On Input script. I found that sometimes the player collides with the coin multiple times before the new level generated, causing the level number variable to increment too far when a new maze is created. I instantiated a coinPickedUp boolean in level generator that gets set to false every time a coin is generated. Then in the grab pick up script, the logic checks to make sure the coin has not yet been picked up when going through the pickup logic. Once the coin is picked up, the boolean is set to true to prevent multiple pick ups before the new maze is loaded.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[X] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
