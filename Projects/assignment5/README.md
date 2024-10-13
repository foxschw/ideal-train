## Submission: Step 1 of 2

## Project Name

Assignment5 - Legend of Zelda

## Your Name

Fox Schwach

## For EACH of the items listed in specifications, provide a sentence or so describing how you accomplished the requirements. 
## Make sure you mention what files your grader should examine, and even better, what line(s) of code you modified.

1. Define a game object in game_object.lua that represents the heart with appropriate parameters, taking advantage of the heart image from the hearts spritesheet. In Room.lua, in the generateEntities function, augment the logic such that each entity has a random possibility to have a heart. Within Room:update, add logic for when an entity dies, alter the logic such that if the entity health is zero and a heart hasn't been spawned, kill the entity and set heart spawned to true. If the entity does have a heart, generate the heart object where the entity has died, add an onConsume function that updates the player's health, removes the heart from the objects table, and plays a sound (thanks Mario). In the PlayerWalkState update function, check over all the objects in the room, and see if the player has collided with a heart and call the onConsume function
2. Add gTextures and gFrames of pot walking/lifting into Dependencies.lua, update the player portion of entity_defs.lua to include this actions. Add pot generation logic to Room.lua. Add player states for lifting and carrying (in my implementation, the player cannot go through an open doorway if carrying a pot), include these state files in Dependencies.lua. In the PlayState, update the self.player.stateMachine array to include these new states. Add key press logic for lifting in idle and walk states. Add a carrying boolean flag to Entity.lua to determine if the player is carrying or not. Create logic for pot collisions in EntityWalkState.lua so that entities can not walk over pots, add a collides function to GameObject.lua (with some offsets for visual consistency). Add logic in PlayerliftState to transition to CarryingState if object is within the hurtbox created by pressing enter. Add tween to pot to place it over player's head. Add a carried flag that changes the state of the pot. Update Room.lua update function so that object update function receives the player as an argument, if carried is true then the pot should track the player (this is done in GameObject.update). Update Room.lua to render any carried objects after everything else.
3. Create a PlayerThrowState, include in the throw state and add correct gFrames line in dependencies, add correct frame orders to entity_defs, include the throw function in the StateMachine array in PlayState. Add a projectile flag as well as a throwDirection reference to GameObject, and include the flag in game_objects. Add logic to allow player to throw from carrying states, adding short animations for side throws. Create a function for thrown projectiles in GameObject (use the throw direction), reference this function in Room:update.

## How would you rate your own design? Place an X in one of the set of brackets below. (Your answer will not have an impact on how the staff scores your design)

[ ] 1 - Poor. Work demonstrates poor understanding of week's concepts and problem set. Substantial improvements needed.

[ ] 2 - Fair. Work demonstrates fair understanding of week's concepts and problem set. Significant improvements needed.

[ ] 3 - Good. Work demonstrates good understanding of week's concepts and problem set. Some improvements needed, but at the benchmark of success for this point in the course.

[ ] 4 - Better. Work demonstrates better than "good" understanding of week's concepts and problem set. Few improvements needed. Beyond the benchmark of success for this point in the course.

[ ] 5 - Best. Exceptional. No room for improvement. No modifications could improve efficiency.

## Instructions

Upload this file to Gradescope for the project in question. Then, proceed to Step 2 of 2 in the submission instructions for your project to upload your code to the shared Dropbox. Remember: Your submission is not considered complete until BOTH steps are complete.
