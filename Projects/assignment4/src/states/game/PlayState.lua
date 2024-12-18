--[[
    GD50
    Super Mario Bros. Remake

    -- PlayState Class --
]]

PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.camX = 0
    self.camY = 0
    -- self.levelWidth = 25
    -- self.level = LevelMaker.generate(25, 10)
    -- self.tileMap = self.level.tileMap
    self.background = math.random(3)
    self.backgroundX = 0

    self.gravityOn = true
    self.gravityAmount = 6

    -- initialize a variable for a drop point X value for the player
    self.dropX = 0


end

function PlayState:enter(params)
    self.newScore = params.score
    -- make sure new width is an integer
    self.newWidth = math.floor(params.newWidth)
    
    -- generate the level and tile map
    self.level = LevelMaker.generate(self.newWidth, 10)
    self.tileMap = self.level.tileMap

        -- determine a good drop point for the main character
        -- iterate over columns to find ground tiles
        for x = 1, self.tileMap.width do
            for y = 1, self.tileMap.height do
                -- if the tile has the ground id, set the x value here and break out of the loop
                if self.level.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    self.dropX = x
                    break
                end
            end
            -- break out of this loop if the variable has been set
            if self.dropX > 0 then
                break
            end
        end
    
        self.player = Player({
            -- employ the dropX variable
            -- convert x to tile size so the player lands directly on the tile (x here refers to coordinates, not tiles)
            x = (self.dropX * TILE_SIZE) - TILE_SIZE, y = 0,
            width = 16, height = 20,
            texture = 'green-alien',
            stateMachine = StateMachine {
                ['idle'] = function() return PlayerIdleState(self.player) end,
                ['walking'] = function() return PlayerWalkingState(self.player) end,
                ['jump'] = function() return PlayerJumpState(self.player, self.gravityAmount) end,
                ['falling'] = function() return PlayerFallingState(self.player, self.gravityAmount) end
            },
            map = self.tileMap,
            level = self.level
        })

        -- 
        self.player.score = self.player.score + self.newScore
    
        self:spawnEnemies()
    
        self.player:changeState('falling')
end 

function PlayState:update(dt)
    Timer.update(dt)

    -- remove any nils from pickups, etc.
    self.level:clear()

    -- update player and level
    self.player:update(dt)
    self.level:update(dt)
    self:updateCamera()

    -- constrain player X no matter which state
    if self.player.x <= 0 then
        self.player.x = 0
    elseif self.player.x > TILE_SIZE * self.tileMap.width - self.player.width then
        self.player.x = TILE_SIZE * self.tileMap.width - self.player.width
    end

    

end

function PlayState:render()
    love.graphics.push()
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256), 0)
    love.graphics.draw(gTextures['backgrounds'], gFrames['backgrounds'][self.background], math.floor(-self.backgroundX + 256),
        gTextures['backgrounds']:getHeight() / 3 * 2, 0, 1, -1)
    
    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))
    
    self.level:render()

    self.player:render()
    love.graphics.pop()
    
    -- render score
    love.graphics.setFont(gFonts['medium'])
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print(tostring(self.player.score), 5, 5)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.print(tostring(self.player.score), 4, 4)
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

--[[
    Adds a series of enemies to the level randomly.
]]
function PlayState:spawnEnemies()
    -- spawn snails in the level
    for x = 1, self.tileMap.width do

        -- flag for whether there's ground on this column of the level
        local groundFound = false

        for y = 1, self.tileMap.height do
            if not groundFound then
                if self.tileMap.tiles[y][x].id == TILE_ID_GROUND then
                    groundFound = true

                    -- random chance, 1 in 20
                    if math.random(20) == 1 then
                        
                        -- instantiate snail, declaring in advance so we can pass it into state machine
                        local snail
                        snail = Snail {
                            texture = 'creatures',
                            x = (x - 1) * TILE_SIZE,
                            y = (y - 2) * TILE_SIZE + 2,
                            width = 16,
                            height = 16,
                            stateMachine = StateMachine {
                                ['idle'] = function() return SnailIdleState(self.tileMap, self.player, snail) end,
                                ['moving'] = function() return SnailMovingState(self.tileMap, self.player, snail) end,
                                ['chasing'] = function() return SnailChasingState(self.tileMap, self.player, snail) end
                            }
                        }
                        snail:changeState('idle', {
                            wait = math.random(5)
                        })

                        table.insert(self.level.entities, snail)
                    end
                end
            end
        end
    end
end