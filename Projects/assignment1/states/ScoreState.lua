--[[
    ScoreState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A simple state used to display the player's score before they
    transition back into the play state. Transitioned to from the
    PlayState when they collide with a Pipe.
]]

ScoreState = Class{__includes = BaseState}

--[[
    When we enter the score state, we expect to receive the score
    from the play state so we know what to render to the State.
]]

-- load medal image assets into variables
local bronze = love.graphics.newImage('bronze.png')
local silver = love.graphics.newImage('silver.png')
local gold = love.graphics.newImage('gold.png')

function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(dt)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    -- show different medals when different scores are achieved
    if self.score <= 4 then
        love.graphics.draw(bronze, VIRTUAL_WIDTH / 2, 215, 0, .35, .35, bronze:getWidth() / 2, bronze:getHeight() / 2)
    elseif self.score <= 9 then
        love.graphics.draw(silver, VIRTUAL_WIDTH / 2, 215, 0, 0.35, 0.35, silver:getWidth() / 2, silver:getHeight() / 2)
    else 
        love.graphics.draw(gold, VIRTUAL_WIDTH / 2, 215, 0, .35, .35, gold:getWidth() / 2, gold:getHeight() / 2)
    end



    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end

