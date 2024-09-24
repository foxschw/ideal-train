--[[
    GD50
    Breakout Remake

    -- PlayState Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents the state of the game in which we are actively playing;
    player should control the paddle, with the ball actively bouncing between
    the bricks, walls, and the paddle. If the ball goes below the paddle, then
    the player should lose one point of health and be taken either to the Game
    Over screen if at 0 health or the Serve screen otherwise.
]]

PlayState = Class{__includes = BaseState}

--[[
    We initialize what's in our PlayState via a state table that we pass between
    states as we go from playing to serving.
]]
function PlayState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.highScores = params.highScores
    self.balls = params.balls
    self.level = params.level

    -- passed in from serve state, should always start as false
    self.hasKey = params.hasKey

    -- initialize counter variable for balls hitting bricks
    -- this ultimately will trigger powerups
    self.hitCounter = 0
    
    -- set an initial random threshold between 7 and 14 hits to determine when to drop a powerup
    self.randomThreshold = math.random(5, 12)

    -- initialize a counter that increments alongside the score, but starts at zero with each new serve
    -- the paddle size will increment after a certain amount of points scored after each serve
    self.pointCounter = 0

    self.recoverPoints = 5000

    -- initialize an empty powerup table to hold active power-ups
    self.powerups = {}

    for i, ball in ipairs(self.balls) do
        -- give ball random starting velocity
        ball.dx = math.random(-200, 200)
        ball.dy = math.random(-50, -60)
    end

end

-- helper function to check if there are any locked bricks in the current level
-- key powerups won't be dropped if this returns false
function PlayState:hasLockedBricks()
    for k, brick in pairs(self.bricks) do
        if brick.locked then
            return true
        end
    end
    return false
end


function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            gSounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        gSounds['pause']:play()
        return
    end

    -- update positions based on velocity
    self.paddle:update(dt)
    
    for i, ball in ipairs(self.balls) do
        ball:update(dt)
    end

    for i, ball in ipairs(self.balls) do
        if ball:collides(self.paddle) then
            -- raise ball above paddle in case it goes below it, then reverse dy
            ball.y = self.paddle.y - 8
            ball.dy = -ball.dy

            --
            -- tweak angle of bounce based on where it hits the paddle
            --

            -- if we hit the paddle on its left side while moving left...
            if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
                ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
            
            -- else if we hit the paddle on its right side while moving right...
            elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
                ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
            end

            gSounds['paddle-hit']:play()
        end
    end

    -- for each ball...
    for i, ball in ipairs(self.balls) do
        -- detect collision across all bricks with the ball
        for k, brick in pairs(self.bricks) do

            -- only check collision if we're in play
            if brick.inPlay and ball:collides(brick) then

                -- only score for unlocked bricks
                if not brick.locked then
                    -- add to score
                    self.score = self.score + (brick.tier * 200 + brick.color * 25)
                    self.pointCounter = self.pointCounter + (brick.tier * 200 + brick.color * 25)
                -- if a locked brick is hit when a key is in play, add a big score
                elseif brick.locked and self.hasKey then
                    self.score = self.score + 10000
                    self.pointCounter = self.pointCounter + 10000
                end
                -- set the pointCounter threshold for increasing paddle size on the condition that
                -- the paddle size isn't at its maximum
                if self.pointCounter > 1000 and self.paddle.size < 4 then
                    -- increment the paddle size to get the right quad
                    self.paddle.size = self.paddle.size + 1
                    -- update the paddle width to accomodate logic that relies on paddle width
                    self.paddle.width = self.paddle.width + 32
                    -- reset the counter
                    self.pointCounter = 0
                end

                -- increment counter if brick is hit
                self.hitCounter = self.hitCounter + 1
                -- threshold of hit bricks for generating powerups
                if self.hitCounter >= self.randomThreshold then

                    local powerupType = nil
                    -- 20% chance to drop a key power-up, but only if there are locked bricks
                    if math.random(1, 5) == 1 and self:hasLockedBricks() then
                        -- Key power-up
                        powerupType = 2
                    else
                        -- Ball power-up
                        powerupType = 1
                    end

                    -- Create a powerup of the specified type and add to table
                    local newPowerup = Powerup(powerupType)
                    table.insert(self.powerups, newPowerup)
                    -- reset counter
                    self.hitCounter = 0
                    -- generate a new threshold for dropping powerups
                    self.randomThreshold = math.random(5, 12)
                end

                -- trigger the brick's hit function, which removes it from play
                -- additionally pass in the hasKey variable
                brick:hit(self.hasKey)

                

                -- if we have enough points, recover a point of health
                if self.score > self.recoverPoints then
                    -- can't go above 3 health
                    self.health = math.min(3, self.health + 1)

                    -- multiply recover points by 2
                    self.recoverPoints = self.recoverPoints + math.min(100000, self.recoverPoints * 2)

                    -- play recover sound effect
                    gSounds['recover']:play()
                end

                -- go to our victory screen if there are no more bricks left
                if self:checkVictory() then
                    gSounds['victory']:play()

                    gStateMachine:change('victory', {
                        level = self.level,
                        paddle = self.paddle,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        balls = self.balls,
                        recoverPoints = self.recoverPoints
                    })
                end

                --
                -- collision code for bricks
                --
                -- we check to see if the opposite side of our velocity is outside of the brick;
                -- if it is, we trigger a collision on that side. else we're within the X + width of
                -- the brick and should check to see if the top or bottom edge is outside of the brick,
                -- colliding on the top or bottom accordingly 
                --

                -- left edge; only check if we're moving right, and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                if ball.x + 2 < brick.x and ball.dx > 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x - 8
                
                -- right edge; only check if we're moving left, , and offset the check by a couple of pixels
                -- so that flush corner hits register as Y flips, not X flips
                elseif ball.x + 6 > brick.x + brick.width and ball.dx < 0 then
                    
                    -- flip x velocity and reset position outside of brick
                    ball.dx = -ball.dx
                    ball.x = brick.x + 32
                
                -- top edge if no X collisions, always check
                elseif ball.y < brick.y then
                    
                    -- flip y velocity and sreset position outside of brick
                    ball.dy = ball.dy
                    ball.y = brick.y - 8
                
                -- bottom edge if no X collisions or top collision, last possibility
                else
                    
                    -- flip y velocity and reset position outside of brick
                    ball.dy = -ball.dy
                    ball.y = brick.y + 16
                end

                -- slightly scale the y velocity to speed up the game, capping at +- 150
                if math.abs(ball.dy) < 150 then
                    ball.dy = ball.dy * 1.02
                end

                -- only allow colliding with one brick, for corners
                break
            end
        end
    end

    -- Update power-up position if it exists
    for i, powerup in ipairs(self.powerups) do
        powerup:update(dt)

        -- Check if it collides with the paddle
        if powerup:collides(self.paddle) then
            
            if powerup.type == 1 then
                -- ball powerup: create 2 balls
                for i = 1, 2 do
                    local newBall = Ball()
                    newBall.skin = math.random(7)
                    --start at paddle center (same logic from ServeState)
                    newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
                    newBall.y = self.paddle.y - 8
                    -- random velocity
                    newBall.dx = math.random(-200, 200)
                    newBall.dy = math.random(-50, -60)
                    -- insert to table
                    table.insert(self.balls, newBall)
                end
            elseif powerup.type == 2 then
                -- key power-up: players hasKey variable switches to true
                self.hasKey = true
            end
            

            -- remove the power-up once collected
            table.remove(self.powerups, i)
        end

        -- remove the powerup from table in reverse order if it goes off-screen
        for i = #self.powerups, 1, -1 do
            if self.powerups[i].y > VIRTUAL_HEIGHT then
                table.remove(self.powerups, i)
            end
        end
    end

    -- for each ball
    for i, ball in ipairs(self.balls) do
    -- if ball goes below bounds, remove it from the ball table
        if ball.y >= VIRTUAL_HEIGHT then
            table.remove(self.balls, i)
            -- if all balls have been removed, go through logic for losing
            if #self.balls == 0 then
                self.health = self.health - 1
                gSounds['hurt']:play()

                -- logic for decreasing paddle size
                if self.paddle.size > 1 then
                    self.paddle.size = self.paddle.size - 1
                    self.paddle.width = self.paddle.width - 32
                end

                if self.health == 0 then
                    gStateMachine:change('game-over', {
                        score = self.score,
                        highScores = self.highScores
                    })
                else
                    gStateMachine:change('serve', {
                        paddle = self.paddle,
                        bricks = self.bricks,
                        health = self.health,
                        score = self.score,
                        highScores = self.highScores,
                        level = self.level,
                        recoverPoints = self.recoverPoints,
                    })
                end
            end
        end
    end

    -- for rendering particle systems
    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    -- render bricks
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    -- render all particle systems
    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    
    -- render all balls that are in play (in the ball table)
    for i, ball in ipairs(self.balls) do
        ball:render()
    end
    
    --render powerups
    for i, powerup in ipairs(self.powerups) do
        powerup:render()
    end

    renderScore(self.score)
    renderHealth(self.health)

    -- pause text, if paused
    if self.paused then
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
    end
end

function PlayState:checkVictory()
    for k, brick in pairs(self.bricks) do
        if brick.inPlay then
            return false
        end 
    end

    return true
end