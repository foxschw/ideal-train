--[[
    GD50
    Super Mario Bros. Remake

    -- LevelMaker Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelMaker = Class{}

function LevelMaker.generate(width, height)
    local tiles = {}
    local entities = {}
    local objects = {}

    local tileID = TILE_ID_GROUND
    
    -- whether we should draw our tiles with toppers
    local topper = true
    local tileset = math.random(20)
    local topperset = math.random(20)

    -- keep track if a lock and key have been spawned
    local keySpawned = false
    local lockSpawned = false
    -- simple variable for key frame/color, can be used to spawn lock of same color
    local randomKeyColor = math.random(#KEYS_AND_LOCKS / 2)
    -- track if key has been obtained
    local keyObtained = false


    -- insert blank tables into tiles for later access
    for x = 1, height do
        table.insert(tiles, {})
    end

    -- column by column generation instead of row; sometimes better for platformers
    for x = 1, width do
        local tileID = TILE_ID_EMPTY
        
        -- lay out the empty space
        for y = 1, 6 do
            table.insert(tiles[y],
                Tile(x, y, tileID, nil, tileset, topperset))
        end

        -- chance to just be emptiness
        if math.random(7) == 1 then
            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, nil, tileset, topperset))
            end
        else
            tileID = TILE_ID_GROUND

            -- height at which we would spawn a potential jump block
            local blockHeight = 4

            for y = 7, height do
                table.insert(tiles[y],
                    Tile(x, y, tileID, y == 7 and topper or nil, tileset, topperset))
            end

            -- chance to generate a pillar
            if math.random(8) == 1 then
                blockHeight = 2
                
                -- chance to generate bush on pillar
                if math.random(8) == 1 then
                    table.insert(objects,
                        GameObject {
                            texture = 'bushes',
                            x = (x - 1) * TILE_SIZE,
                            y = (4 - 1) * TILE_SIZE,
                            width = 16,
                            height = 16,
                            
                            -- select random frame from bush_ids whitelist, then random row for variance
                            frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                            collidable = false
                        }
                    )
                end

                -- possible to generate a key on a pillar
                -- check if key has been spawned
                if not keySpawned then
                    -- create key towards second half of level
                    if x > math.floor(width / 2) and x < width then
                        if math.random(15) == 1 then
                            table.insert(objects,
                                GameObject {
                                    texture = 'keys-and-locks',
                                    x = (x - 1) * TILE_SIZE,
                                    y = (4 - 1) * TILE_SIZE,
                                    width = 16,
                                    height = 16,
                                    -- only use first half of sprite sheet, keys
                                    frame = randomKeyColor,
                                    collidable = true,
                                    consumable = true,
                                    solid = false,

                                    -- play a sound when consumed
                                    onConsume = function(player, object)
                                        gSounds['pickup']:play()
                                        keyObtained = true
                                    end
                                }
                            )
                            keySpawned = true
                        end
                    end
                end
                
                -- pillar tiles
                tiles[5][x] = Tile(x, 5, tileID, topper, tileset, topperset)
                tiles[6][x] = Tile(x, 6, tileID, nil, tileset, topperset)
                tiles[7][x].topper = nil
            
            -- chance to generate bushes
            elseif math.random(8) == 1 then
                table.insert(objects,
                    GameObject {
                        texture = 'bushes',
                        x = (x - 1) * TILE_SIZE,
                        y = (6 - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,
                        frame = BUSH_IDS[math.random(#BUSH_IDS)] + (math.random(4) - 1) * 7,
                        collidable = false
                    }
                )
            end

            -- possible to generate a key on ground
            -- check if key has been spawned
            if not keySpawned then
                -- create key towards second half of level
                if x > math.floor(width / 2) and x < width then
                    if math.random(15) == 1 then
                        table.insert(objects,
                            GameObject {
                                texture = 'keys-and-locks',
                                x = (x - 1) * TILE_SIZE,
                                y = (6 - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                -- only use first half of sprite sheet, keys
                                frame = randomKeyColor,
                                collidable = true,
                                consumable = true,
                                solid = false,

                                -- play a sound
                                onConsume = function(player, object)
                                    gSounds['pickup']:play()
                                    keyObtained = true
                                end
                            }
                        )
                        keySpawned = true
                    end
                end
            end

            -- chance to spawn a block, make sure not sandwiched between pillars
            if math.random(10) == 1 and not LevelMaker:pillarCheck(tiles, x, 5) then

                table.insert(objects,

                    -- jump block
                    GameObject {
                        texture = 'jump-blocks',
                        x = (x - 1) * TILE_SIZE,
                        y = (blockHeight - 1) * TILE_SIZE,
                        width = 16,
                        height = 16,

                        -- make it a random variant
                        frame = math.random(#JUMP_BLOCKS),
                        collidable = true,
                        consumable = true,
                        hit = false,
                        solid = true,

                        -- collision function takes itself
                        onCollide = function(obj)

                            -- spawn a gem if we haven't already hit the block
                            if not obj.hit then

                                -- chance to spawn gem, not guaranteed
                                if math.random(5) == 1 then

                                    -- maintain reference so we can set it to nil
                                    local gem = GameObject {
                                        texture = 'gems',
                                        x = (x - 1) * TILE_SIZE,
                                        y = (blockHeight - 1) * TILE_SIZE - 4,
                                        width = 16,
                                        height = 16,
                                        frame = math.random(#GEMS),
                                        collidable = true,
                                        consumable = true,
                                        solid = false,

                                        -- gem has its own function to add to the player's score
                                        onConsume = function(player, object)
                                            gSounds['pickup']:play()
                                            player.score = player.score + 100
                                        end
                                    }
                                    
                                    -- make the gem move up from the block and play a sound
                                    Timer.tween(0.1, {
                                        [gem] = {y = (blockHeight - 2) * TILE_SIZE}
                                    })
                                    gSounds['powerup-reveal']:play()

                                    table.insert(objects, gem)
                                end

                                obj.hit = true
                            end

                            gSounds['empty-block']:play()
                        end
                    }
                )  
                
            end

            -- spawn lock box
            if not lockSpawned then
                -- spawn in first half of play area, make sure not sandwiched between pillars
                if x < math.floor(width / 2) and x > 1 then
                    if math.random(15) == 1 and not LevelMaker:pillarCheck(tiles, x, 5) then
                        local lockBox = GameObject {
                                texture = 'keys-and-locks',
                                x = (x - 1) * TILE_SIZE,
    
                                y = (blockHeight - 1) * TILE_SIZE,
                                width = 16,
                                height = 16,
                                -- match lock color to key color
                                frame = (randomKeyColor + 4),
                                collidable = true,
                                consumable = true,
                                hit = false,
                                solid = true,

                                -- collision function takes itself
                                onCollide = function(obj)

                                    if not obj.hit then
                                        obj.hit = true
                                    end
                                    -- if the player has obtained the key and hits the box...
                                    if obj.hit and keyObtained then
                                        -- find the box in the table
                                        for i, v in ipairs(objects) do
                                            if objects[i] == obj then
                                                -- remove the box from the table
                                                table.remove(objects, i)
                                                -- play a sound
                                                gSounds['pickup']:play()
                                            end
                                        end
                                        -- run flag spawning logic
                                        spawnFlagAtGround(objects, tiles, width, height)
                                    end

                                    gSounds['empty-block']:play()
                                end   
                            }

                        table.insert(objects, lockBox)
                        lockSpawned = true
                    end
                end
            end
        end
    end

    -- if a key/lock was never generated, regenerate the level
    if not (keySpawned and lockSpawned) then
        return LevelMaker.generate(width, height)
    end

    local map = TileMap(width, height)
    map.tiles = tiles
    
    return GameLevel(entities, objects, map)
end

 -- helper function to check if the left and right columns of an object are pillars
function LevelMaker:pillarCheck(tiles, x, pillarHeight)

    
    local leftPillar = false
    -- stay in bounds
    if x > 1 then
        -- check if there is a pillar to the left
        if tiles[pillarHeight][x - 1].id == TILE_ID_GROUND then
            leftPillar = true
        end
    end

    -- check if there is a pillar to the right
    local rightPillar = false
    if x < #tiles[1] then
        if tiles[pillarHeight][x + 1].id == TILE_ID_GROUND then
            rightPillar = true
        end
    end

    -- return true if both sides are pillars
    return leftPillar and rightPillar
end

-- function to spawn the flag on solid ground
function spawnFlagAtGround(objects, tiles, width, height)
    -- start with initial ideal flag column (the column before the last column, to make room for flag)
    local flagColumn = width - 1

    -- initialize variable to store the ground's y-coordinate
    local groundY = nil

    -- function to find the ground in a given column
    local function findGround(column)
        for y = 1, height do
            if tiles[y][column].id == TILE_ID_GROUND then
                -- account for pixel array starting at 0 not 1
                return (y - 1)
            end
        end
        return nil -- Return nil if no ground is found
    end

    -- try to find ground in the flagColumn first
    groundY = findGround(flagColumn)

    -- if no ground is found, search to the left and there is still tiles that exist to the left
    local offset = 1
    while not groundY and flagColumn - offset > 0 do
        -- check left
        groundY = findGround(flagColumn - offset)
        if groundY then
            -- adjust column to the new location
            flagColumn = flagColumn - offset 
            break
        end
        -- increase offset if no ground
        offset = offset + 1
    end

    -- spawn the flag and flagpole at the correct height (on the ground)
    table.insert(objects, 
        GameObject {
            texture = 'flags',
            -- place at flagColumn, far enough away to make room for flag
            x = (flagColumn - 1) * TILE_SIZE,
            y = (groundY - 3) * TILE_SIZE,
            width = 16,
            height = 48,
            frame = math.random(6),
            collidable = true,
            consumable = true,
            solid = false,
            isPole = true,
            
            -- flagpole collision logic
            onConsume = function(player, object)
                gSounds['pickup']:play()
                --generate new level if pole is consumed
                gStateMachine:change('play', {
                    score = player.score,
                    newWidth = width * 1.1
                })
            end
        }
    )

    -- generate flag on flag pole
    table.insert (objects, 
        GameObject {
            texture = 'flags',
            -- position flag on the pole in right place
            x = (flagColumn - 1) * TILE_SIZE + (TILE_SIZE / 2),
            y = (groundY - 3) * TILE_SIZE + (TILE_SIZE / 3),
            width = 16,
            height = 16,
            -- use standard render logic, but reference whitelisted sections of sprite sheet
            frame = FLAGS[math.random(#FLAGS)],
            collidable = false,
            consumable = false,
            solid = false,
        }    
    )
end