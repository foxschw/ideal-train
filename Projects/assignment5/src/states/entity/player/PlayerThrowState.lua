--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerThrowState = Class{__includes = BaseState}

function PlayerThrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction
    -- local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    -- if direction == 'left' then
    --     hitboxWidth = 8
    --     hitboxHeight = 16
    --     hitboxX = self.player.x - hitboxWidth
    --     hitboxY = self.player.y + 2
    -- elseif direction == 'right' then
    --     hitboxWidth = 8
    --     hitboxHeight = 16
    --     hitboxX = self.player.x + self.player.width
    --     hitboxY = self.player.y + 2
    -- elseif direction == 'up' then
    --     hitboxWidth = 16
    --     hitboxHeight = 8
    --     hitboxX = self.player.x
    --     hitboxY = self.player.y - hitboxHeight
    -- else
    --     hitboxWidth = 16
    --     hitboxHeight = 8
    --     hitboxX = self.player.x
    --     hitboxY = self.player.y + self.player.height
    -- end

    -- -- separate hitbox for the player's sword; will only be active during this state
    -- self.swordHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)

    -- lift-left, lift-up, etc
    self.player:changeAnimation('throw-' .. self.player.direction)
end

function PlayerThrowState:enter(params)

    -- restart sword swing sound for rapid swinging
    gSounds['sword']:stop()
    gSounds['sword']:play()

    -- restart sword swing animation
    self.player.currentAnimation:refresh()
end

function PlayerThrowState:update(dt)
    
    for k, object in pairs(self.dungeon.currentRoom.objects) do
        if object.carried then
            -- update player and change state
            self.player.carrying = false
            
            
            -- update the object and animate it to the correct position
            object.solid = true
            object.carried = false
             -- set initial startX and startY only when the object is first thrown
            if not object.startX or not object.startY then
                object.startX = object.x
                object.startY = object.y
            end

            -- set the throw direction to the player's current direction
            object.throwDirection = self.player.direction
            
            -- animate the pot diagonally slightly for sideways throws, enable the projectile value
            if self.player.direction == 'left' then
                Timer.tween(0.11, {
                    [object] = {y = self.player.y, x = self.player.x - object.width}
                }):finish(function()
                    object.projectile = true
                    -- set start XY values to eventually determine start of throw
                    object.startX = object.x 
                    object.startY = object.y
                end)
            elseif self.player.direction == 'right' then
                Timer.tween(0.11, {
                    [object] = {y = self.player.y, x = self.player.x + self.player.width}
                }):finish(function()
                    object.projectile = true
                    object.startX = object.x 
                    object.startY = object.y
                end)
            else
                object.projectile = true
                object.startX = object.x 
                object.startY = object.y
            end
        end
    end

    -- if we've fully elapsed through one cycle of animation, change back to idle state
    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

end

function PlayerThrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    --
    -- debug for player and hurtbox collision rects VV
    --

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHitbox.x, self.swordHitbox.y,
    --     self.swordHitbox.width, self.swordHitbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end