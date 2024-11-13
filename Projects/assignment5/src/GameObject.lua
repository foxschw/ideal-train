--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)
    
    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height

    self.player = def.player

    -- determine if object is in a projectile state
    self.projectile = def.projectile

    -- reference later once an object is thrown
    self.throwDirection = nil

    -- track the initial position when thrown
    self.startX = nil
    self.startY = nil

    -- default empty collision and consume callback
    self.onCollide = function() end

    self.onConsume = function() end
end

function GameObject:update(player, dt)
    if self.carried then
        self.x = player.x
        self.y = player.y - self.height + 3
    end
end

-- collision detection for objects with a slight offest to bottom to accomodate viewing angle
-- and to let entities get visually closer
function GameObject:collides(target)
    return not (self.x + (self.width - 2) < target.x or (self.x + 2) > target.x + target.width or
                self.y + (self.height - 12) < target.y or (self.y + 2) > target.y + target.height)
end

function GameObject:throwProjectile(player, dt)
    -- collision buffer that delays collision checks for a short time after throwing
    -- takes care of edge cases where pot is rendered on top of wall due to perspective
    if not self.collisionBuffer then
        self.collisionBuffer = 0.4
    end

    -- update the buffer timer
    if self.collisionBuffer > 0 then
        self.collisionBuffer = self.collisionBuffer - dt
    end
    
    -- speed of projectile
    local speed = 45
    -- move the object in the direction it was thrown
    if self.throwDirection == 'right' then
        self.x = self.x + speed * dt
    elseif self.throwDirection == 'left' then
        self.x = self.x - speed * dt
    elseif self.throwDirection == 'up' then
        self.y = self.y - speed * dt
    elseif self.throwDirection == 'down' then
        self.y = self.y + speed * dt
    end
end

function GameObject:render(adjacentOffsetX, adjacentOffsetY)
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)
end