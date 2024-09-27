--[[
    GD50
    Match-3 Remake

    -- Tile Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The individual tiles that make up our game board. Each Tile can have a
    color and a variety, with the varietes adding extra points to the matches.
]]

Tile = Class{}

function Tile:init(x, y, color, variety, shiny)
    
    -- board positions
    self.gridX = x
    self.gridY = y

    -- coordinate positions
    self.x = (self.gridX - 1) * 32
    self.y = (self.gridY - 1) * 32

    -- tile appearance/points
    self.color = color
    self.variety = variety
    self.isShiny = shiny

    -- Use the particle image (from Breakout)
    local particleImage = love.graphics.newImage('graphics/particle.png')

    -- Initialize the particle system
    self.particleSystem = love.graphics.newParticleSystem(particleImage, 100)
    self.particleSystem:setParticleLifetime(0.5, 1.5)
    self.particleSystem:setEmissionRate(3)
    self.particleSystem:setSizeVariation(1)
    self.particleSystem:setSizes(.3, 3)
    self.particleSystem:setLinearAcceleration(-20, -20, 20, 20)
    self.particleSystem:setColors(1, 1, 1, 1, 1, 1, 1, 0)
    self.particleSystem:start()
end

function Tile:update(dt)
        -- update the particle system
        if self.isShiny then
            -- set the particle system's position to the tile's center
            self.particleSystem:setPosition(self.x + 16, self.y + 16)
            
            -- update the particle system with delta time
            self.particleSystem:update(dt)
        end
end

function Tile:render(x, y)
    
    -- draw shadow
    love.graphics.setColor(34/255, 32/255, 52/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x + 2, self.y + y + 2)

    -- draw tile itself

    love.graphics.setColor(255/255, 255/255, 255/255, 255/255)
    love.graphics.draw(gTextures['main'], gFrames['tiles'][self.color][self.variety],
        self.x + x, self.y + y)
    if self.isShiny then
        -- Draw the particle system
        love.graphics.draw(self.particleSystem, x, y)
    end
end