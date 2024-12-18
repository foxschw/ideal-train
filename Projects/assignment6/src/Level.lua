--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Level = Class{}

function Level:init()
    
    -- create a new "world" (where physics take place), with no x gravity
    -- and 30 units of Y gravity (for downward force)
    self.world = love.physics.newWorld(0, 300)

    -- bodies we will destroy after the world update cycle; destroying these in the
    -- actual collision callbacks can cause stack overflow and other errors
    self.destroyedBodies = {}

    -- counter for aliens that have stopped rolling
    self.counter = 0

    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)

        local types = {}
        -- userData is a table and we are looking for the role parameter
        types[a:getUserData().role] = true
        types[b:getUserData().role] = true

        -- if we collided between both the player and an obstacle...
        if types['Obstacle'] and types['Player'] then

            -- grab the body that belongs to the player
            local playerFixture = a:getUserData().role == 'Player' and a or b
            local obstacleFixture = a:getUserData().role == 'Obstacle' and a or b
            
            -- destroy the obstacle if player's combined X/Y velocity is high enough
            local velX, velY = playerFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)

            if sumVel > 20 then
                table.insert(self.destroyedBodies, obstacleFixture:getBody())
            end

            -- set collided flag of player to true if player and obstacle collide
            if not playerFixture:getUserData().collided then
                playerFixture:getUserData().collided = true
            end

        end

        -- if we collided between an obstacle and an alien, as by debris falling...
        if types['Obstacle'] and types['Alien'] then

            -- grab the body that belongs to the player
            local obstacleFixture = a:getUserData().role == 'Obstacle' and a or b
            local alienFixture = a:getUserData().role == 'Alien' and a or b

            -- destroy the alien if falling debris is falling fast enough
            local velX, velY = obstacleFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)

            if sumVel > 20 then
                table.insert(self.destroyedBodies, alienFixture:getBody())
            end
        end

        -- if we collided between the player and the alien...
        if types['Player'] and types['Alien'] then

            -- grab the bodies that belong to the player and alien
            local playerFixture = a:getUserData().role == 'Player' and a or b
            local alienFixture = a:getUserData().role == 'Alien' and a or b

            -- destroy the alien if player is traveling fast enough
            local velX, velY = playerFixture:getBody():getLinearVelocity()
            local sumVel = math.abs(velX) + math.abs(velY)

            if sumVel > 20 then
                table.insert(self.destroyedBodies, alienFixture:getBody())
            end

            -- set collided flag of player to true if player and alien collide
            if not playerFixture:getUserData().collided then
                playerFixture:getUserData().collided = true
            end
        end

        -- if we hit the ground, play a bounce sound
        if types['Player'] and types['Ground'] then
            gSounds['bounce']:stop()
            gSounds['bounce']:play()

            local playerFixture = a:getUserData().role == 'Player' and a or b
            
            -- set collided flag of player to true if player and ground collide
            if not playerFixture:getUserData().collided then
                playerFixture:getUserData().collided = true
            end
        end

    end

    -- the remaining three functions here are sample definitions, but we are not
    -- implementing any functionality with them in this demo; use-case specific
    -- http://www.iforce2d.net/b2dtut/collision-anatomy
    function endContact(a, b, coll)
        
    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    -- register just-defined functions as collision callbacks for world
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- shows alien before being launched and its trajectory arrow
    self.launchMarker = AlienLaunchMarker(self.world)

    -- aliens in our scene
    self.aliens = {}

    -- obstacles guarding aliens that we can destroy
    self.obstacles = {}

    -- simple edge shape to represent collision for ground
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

    -- wall offscreen right to stop aliens from rolling too far
    -- users don't have to wait forever for aliens to stop rolling
    self.wallShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT * 2)

    -- spawn an alien to try and destroy
    table.insert(self.aliens, Alien(self.world, 'square', VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - TILE_SIZE - ALIEN_SIZE / 2, {role = 'Alien', collided = false}))

    -- spawn a few obstacles
    table.insert(self.obstacles, Obstacle(self.world, 'vertical',
        VIRTUAL_WIDTH - 120, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'vertical',
        VIRTUAL_WIDTH - 35, VIRTUAL_HEIGHT - 35 - 110 / 2))
    table.insert(self.obstacles, Obstacle(self.world, 'horizontal',
        VIRTUAL_WIDTH - 80, VIRTUAL_HEIGHT - 35 - 110 - 35 / 2))

    -- ground data
    self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - 35, 'static')
    self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
    self.groundFixture:setFriction(0.5)
    self.groundFixture:setUserData({role = 'Ground', collided = false})

    -- wall data
    self.wallBody = love.physics.newBody(self.world, VIRTUAL_WIDTH * 2, 0, 'static')
    self.wallFixture = love.physics.newFixture(self.wallBody, self.wallShape)
    self.wallFixture:setFriction(0.5)
    -- the role can stay ground since it should behave the same
    self.wallFixture:setUserData({role = 'Ground', collided = false})

    -- background graphics
    self.background = Background()
end

function Level:update(dt)
    
    -- update launch marker, which shows trajectory
    self.launchMarker:update(dt)

    -- Box2D world update code; resolves collisions and processes callbacks
    self.world:update(dt)

    -- destroy all bodies we calculated to destroy during the update call
    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then 
            body:destroy()
        end
    end

    -- reset destroyed bodies to empty table for next update phase
    self.destroyedBodies = {}

    -- remove all destroyed obstacles from level
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)

            -- play random wood sound effect
            local soundNum = math.random(5)
            gSounds['break' .. tostring(soundNum)]:stop()
            gSounds['break' .. tostring(soundNum)]:play()
        end
    end

    -- remove all destroyed aliens from level
    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
            gSounds['kill']:stop()
            gSounds['kill']:play()
        end
    end

    -- replace launch marker if aliens stopped moving
    if self.launchMarker.launched then

        -- set flags for moving and offscreen
        local stoppedFlag = true
        local offScreen = false
        
        for i = #self.launchMarker.aliens, 1, -1 do

            -- get positions and velocities of all aliens
            local xPos, yPos = self.launchMarker.aliens[i].body:getPosition()
            local xVel, yVel = self.launchMarker.aliens[i].body:getLinearVelocity()

            -- stoppedFlag starts true, but flips to false and remains false as long as any aliens are moving for every cycle of update phase
            -- if all aliens have stopped, stoppedFlag won't be flipped to false and remain true from before, which will trigger launchMarker
            if (math.abs(xVel) + math.abs(yVel) > 1.5) then
                stoppedFlag = false
            end

            -- flip to true if any alien goes offscreen left
            if xPos < 0 then
                offScreen = true
                break
            end
        end
        
        -- if we fired our alien to the left or it's almost done rolling, respawn, or if all aliens have stopped
        -- if any aliens go offscreen to left, the launchMarker will respawn.
        if stoppedFlag or offScreen then
            for i = #self.launchMarker.aliens, 1, -1 do
                self.launchMarker.aliens[i].body:destroy()
            end
            
            
            self.launchMarker = AlienLaunchMarker(self.world)

            -- re-initialize level if we have no more aliens
            if #self.aliens == 0 then
                gStateMachine:change('start')
            end
        end
    end
end

function Level:render()
    
    -- render ground tiles across full scrollable width of the screen
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35 do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    self.launchMarker:render()

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    -- render instruction text if we haven't launched bird
    if not self.launchMarker.launched then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('Click and drag circular alien to shoot!',
            0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end

    -- render victory text if all aliens are dead
    if #self.aliens == 0 then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1, 1, 1, 1)
    end
end