Powerup = Class{}

function Powerup:init(type)
    -- simple positional and dimensional variables
    self.width = 16
    self.height = 16

    -- determine a variable for ball powerup or key powerup
    self.type = type

    -- x is placed randomly within the a 16 px buffer of the width
    self.x = math.random(16, VIRTUAL_WIDTH - 32)

    -- y is placed above the screen
    self.y = -18

    -- this variable is speed of falling powerup
    self.dy = math.random(10, 200)

end

--[[
    Expects an argument with a bounding box, be that a paddle or a brick,
    and returns true if the bounding boxes of this and the argument overlap.
]]
function Powerup:collides(target)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x > target.x + target.width or target.x > self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y > target.y + target.height or target.y > self.y + self.height then
        return false
    end 

    -- if the above aren't true, they're overlapping
    return true
end

-- apply velocity downward when called
function Powerup:update(dt)
    self.y = self.y + self.dy * dt
end

function Powerup:render()
    -- Index into the powerups table created in util.lua
    -- 1 is for ball, 2 is for key
    local spriteIndex = self.type == 2 and 2 or 1
    love.graphics.draw(gTextures['main'], gFrames['powerups'][spriteIndex], self.x, self.y)
end