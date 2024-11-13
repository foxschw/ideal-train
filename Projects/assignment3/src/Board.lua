--[[
    GD50
    Match-3 Remake

    -- Board Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Board is our arrangement of Tiles with which we must try to find matching
    sets of three horizontally or vertically.
]]

Board = Class{}

function Board:init(x, y, level)
    self.x = x
    self.y = y
    self.level = level
    self.matches = {}

    self:initializeTiles()
end

-- helper function to create a table that can be used for tile generation that makes lower variety numbers more probable
function Board:getWeightedVariety(level)
    --create an empty table for varieties
    local varieties = {}
    --iterate over level
    for i = 1, math.min(6, level) do
        -- lower numbers get added more times to the table than higher numbers which will make them more probable
        for j = 1, 14 - i * 2 do
            table.insert(varieties, i)
        end
    end
    -- return a variety at random
    return varieties[math.random(#varieties)]
end

-- helper function to see if matches are possible with a baord that has been initialized
-- if no matches, board will re-initialize
function Board:checkPossibilities()
    -- track if a match has been found
    local possibleMatchFound = false

    -- HORIZONTAL SWAP
    -- loop through all tiles
    for y = 1, 8 do
        -- check horizontal swaps to the right, don't bother with the last column
        for x = 1, 7 do
            -- swap tiles horizontally
            self.tiles[y][x], self.tiles[y][x + 1] = self.tiles[y][x + 1], self.tiles[y][x]
            
            -- check for matches with swapped tiles
            local matches = self:calculateMatches()
            
            -- swap the tiles back
            self.tiles[y][x], self.tiles[y][x + 1] = self.tiles[y][x + 1], self.tiles[y][x]
            
            -- if any match is found, set the flag to true
            if matches then
                possibleMatchFound = true
            end
        end
    end
            
    -- VERTICAL SWAP
    -- loop through all tiles, don't bother with last row
    for y = 1, 7 do
        for x = 1, 8 do
            -- swap tiles vertically
            self.tiles[y][x], self.tiles[y + 1][x] = self.tiles[y + 1][x], self.tiles[y][x]
            
            -- check for matches with swapped tiles
            local matches = self:calculateMatches()
            
            -- swap the tiles back
            self.tiles[y][x], self.tiles[y + 1][x] = self.tiles[y + 1][x], self.tiles[y][x]
            
            -- if any match is found, set the flag to true
            if matches then
                possibleMatchFound = true
            end
        end
    end

    -- if no possible match was found, reinitialize the board
    if not possibleMatchFound then
        self:initializeTiles()
    end
end

function Board:initializeTiles()
    self.tiles = {}

    for tileY = 1, 8 do
        
        -- empty table that will serve as a new row
        table.insert(self.tiles, {})

        for tileX = 1, 8 do
            -- only use every other row of colors  rather than all possible colors
            local color = (math.random(9) - 1) * 2 + 1
            -- generate shiny tiles randomly
            local isShiny = false
            if math.random(20) == 1 then
                isShiny = true
            end
            -- create a new tile at X,Y with a random color and variety
            -- use the getWeightedVariety function to weight the variety to lower numbers
            table.insert(self.tiles[tileY], Tile(tileX, tileY, color, self:getWeightedVariety(self.level), isShiny)) 
        end
    end

    while self:calculateMatches() do
        
        -- recursively initialize if matches were returned so we always have
        -- a matchless board on start
        self:initializeTiles()
    end
    self:checkPossibilities()
end



--[[
    Goes left to right, top to bottom in the board, calculating matches by counting consecutive
    tiles of the same color. Doesn't need to check the last tile in every row or column if the 
    last two haven't been a match.
]]
function Board:calculateMatches()
    local matches = {}

    -- how many of the same color blocks in a row we've found
    local matchNum = 1

    -- horizontal matches first
    for y = 1, 8 do
        local colorToMatch = self.tiles[y][1].color

        matchNum = 1
        
        -- every horizontal tile
        for x = 2, 8 do
            
            -- if this is the same color as the one we're trying to match...
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                
                -- set this as the new color we want to watch for
                colorToMatch = self.tiles[y][x].color

                -- if we have a match of 3 or more up to now, add it to our matches table
                if matchNum >= 3 then
                    local match = {}

                    -- go backwards from here by matchNum
                    for x2 = x - 1, x - matchNum, -1 do

                        -- check if there's a shiny tile in the match
                        if self.tiles[y][x2].isShiny then
                            --iterate over the whole row and add every tile to the match in order to eliminate the whole row
                            for i = 1, 8 do
                                table.insert(match, self.tiles[y][i])
                            end     
                        else
                        
                            -- add each tile to the match that's in that match
                            table.insert(match, self.tiles[y][x2])
                        end
                    end

                    -- add this match to our total matches table
                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if x >= 7 then
                    break
                end
            end
        end

        -- account for the last row ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for x = 8, 8 - matchNum + 1, -1 do
                -- check if there's a shiny tile in the match
                if self.tiles[y][x].isShiny then
                    --iterate over the whole row and add every tile to the match in order to eliminate the whole row
                    for i = 1, 8 do
                        table.insert(match, self.tiles[y][i])
                    end     
                else
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- vertical matches
    for x = 1, 8 do
        local colorToMatch = self.tiles[1][x].color

        matchNum = 1

        -- every vertical tile
        for y = 2, 8 do
            if self.tiles[y][x].color == colorToMatch then
                matchNum = matchNum + 1
            else
                colorToMatch = self.tiles[y][x].color

                if matchNum >= 3 then
                    local match = {}

                    for y2 = y - 1, y - matchNum, -1 do
                        -- if any tile in the match is shiny, clear the whole row
                        if self.tiles[y2][x].isShiny then
                            for i = 1, 8 do
                                table.insert(match, self.tiles[y2][i])
                            end
                        else
                            table.insert(match, self.tiles[y2][x])
                        end
                    end

                    table.insert(matches, match)
                end

                matchNum = 1

                -- don't need to check last two if they won't be in a match
                if y >= 7 then
                    break
                end
            end
        end

        -- account for the last column ending with a match
        if matchNum >= 3 then
            local match = {}
            
            -- go backwards from end of last row by matchNum
            for y = 8, 8 - matchNum + 1, -1 do
                -- if any tile in this vertical match is shiny, clear the whole row
                if self.tiles[y][x].isShiny then
                    for i = 1, 8 do
                        table.insert(match, self.tiles[y][i])
                    end
                else
                    table.insert(match, self.tiles[y][x])
                end
            end

            table.insert(matches, match)
        end
    end

    -- store matches for later reference
    self.matches = matches

    -- return matches table if > 0, else just return false
    return #self.matches > 0 and self.matches or false
end

--[[
    Remove the matches from the Board by just setting the Tile slots within
    them to nil, then setting self.matches to nil.
]]
function Board:removeMatches()
    for k, match in pairs(self.matches) do
        for k, tile in pairs(match) do
            self.tiles[tile.gridY][tile.gridX] = nil
        end
    end

    self.matches = nil
end

--[[
    Shifts down all of the tiles that now have spaces below them, then returns a table that
    contains tweening information for these new tiles.
]]
function Board:getFallingTiles()
    -- tween table, with tiles as keys and their x and y as the to values
    local tweens = {}

    -- for each column, go up tile by tile till we hit a space
    for x = 1, 8 do
        local space = false
        local spaceY = 0

        local y = 8
        while y >= 1 do
            
            -- if our last tile was a space...
            local tile = self.tiles[y][x]
            
            if space then
                
                -- if the current tile is *not* a space, bring this down to the lowest space
                if tile then
                    
                    -- put the tile in the correct spot in the board and fix its grid positions
                    self.tiles[spaceY][x] = tile
                    tile.gridY = spaceY

                    -- set its prior position to nil
                    self.tiles[y][x] = nil

                    -- tween the Y position to 32 x its grid position
                    tweens[tile] = {
                        y = (tile.gridY - 1) * 32
                    }

                    -- set Y to spaceY so we start back from here again
                    space = false
                    y = spaceY

                    -- set this back to 0 so we know we don't have an active space
                    spaceY = 0
                end
            elseif tile == nil then
                space = true
                
                -- if we haven't assigned a space yet, set this to it
                if spaceY == 0 then
                    spaceY = y
                end
            end

            y = y - 1
        end
    end

    -- create replacement tiles at the top of the screen
    for x = 1, 8 do
        for y = 8, 1, -1 do
            local tile = self.tiles[y][x]

            -- if the tile is nil, we need to add a new one
            if not tile then

                -- initialize a tile variabl
                local tile
                -- only use every other row of colors  rather than all possible colors
                local color = (math.random(9) - 1) * 2 + 1
                local isShiny = false
                -- randomly generate shiny particles
                if math.random(20) == 1 then
                    isShiny = true
                end
                
                -- new tile with random color and variety
                -- use the getWeightedVariety function to weight the variety to lower numbers
                tile = Tile(x, y, color, self:getWeightedVariety(self.level), isShiny)
                
                tile.y = -32
                self.tiles[y][x] = tile

                -- create a new tween to return for this tile to fall down
                tweens[tile] = {
                    y = (tile.gridY - 1) * 32
                }
            end
        end
    end
    -- make sure there are still new match possibilities after new tiles have been added
    self:checkPossibilities()

    return tweens
end

-- include an update function for making particle systems
function Board:update(dt)
    -- loop through all the tiles on the board and update them
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            -- update each tile (this will update the particle system for shiny tiles)
            self.tiles[y][x]:update(dt)
        end
    end
end

function Board:render()
    for y = 1, #self.tiles do
        for x = 1, #self.tiles[1] do
            self.tiles[y][x]:render(self.x, self.y)
        end
    end
end