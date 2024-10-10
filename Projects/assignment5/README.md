## Submission: Step 1 of 2

## Project Name

Assignment5 - Legend of Zelda

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Define a game object in game_object.lua that represents the heart with appropriate parameters, taking advantage of the heart image from the hearts spritesheet. In Room.lua, in the generateEntities function, augment the logic such that each entity has a random possibility to have a heart. Within Room:update, add logic for when an entity dies, alter the logic such that if the entity health is zero and a heart hasn't been spawned, kill the entity and set heart spawned to true. If the entity does have a heart, generate the heart object where the entity has died, add an onConsume function that updates the player's health, removes the heart from the objects table, and plays a sound (thanks Mario). In the PlayerWalkState update function, check over all the objects in the room, and see if the player has collided with a heart and call the onConsume function
2.
3.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
