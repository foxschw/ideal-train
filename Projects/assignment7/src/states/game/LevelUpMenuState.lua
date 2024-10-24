--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState, HPIncrease, attackIncrease, defenseIncrease, speedIncrease)
    
    self.battleState = battleState
    
    -- subtract the increase value from the newly leveled up value to get what it was before the fight
    self.originalHP = self.battleState.playerPokemon.HP - HPIncrease
    self.originalAttack = self.battleState.playerPokemon.attack - attackIncrease
    self.originalDefense = self.battleState.playerPokemon.defense - defenseIncrease
    self.originalSpeed = self.battleState.playerPokemon.speed - speedIncrease
    
    self.levelUpMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH,
        height = 64,
        font = gFonts['small'],
        type = 'display',
        -- compose/concatenate phrases for the menu
        items = {
            {
                text = ('HP: ' .. self.originalHP .. ' + ' .. HPIncrease .. ' = ' .. self.battleState.playerPokemon.HP),
                onSelect = function () self:leaveMenu() end
            },
            {
                text = ('Attack: ' .. self.originalAttack .. ' + ' .. attackIncrease .. ' = ' .. self.battleState.playerPokemon.attack),
                onSelect = function () self:leaveMenu() end
            },
            {
                text = ('Defense: ' .. self.originalDefense .. ' + ' .. defenseIncrease .. ' = ' .. self.battleState.playerPokemon.defense),
                onSelect = function () self:leaveMenu() end
            },
            {
                text = ('Speed: ' .. self.originalSpeed .. ' + ' .. speedIncrease .. ' = ' .. self.battleState.playerPokemon.speed),
                onSelect = function () self:leaveMenu() end
            }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end

function LevelUpMenuState:leaveMenu()



    -- fade in white
    gStateStack:push(FadeInState({
            r = 1, g = 1, b = 1
        }, 1,
        
        -- pop message and battle state and add a fade to blend in the field
        -- similar to TakeTurnState:fadeOutWhite() but we need to pop an extra state
        function()
            -- resume field music
            gSounds['victory-music']:stop()
            gSounds['field-music']:play()

            -- pop levelup menu
            gStateStack:pop()
            
            -- pop message state state
            gStateStack:pop()
            
            -- pop battle state
            gStateStack:pop()

            -- fade to field
            gStateStack:push(FadeOutState({
                r = 1, g = 1, b = 1
            }, 1, function()
                -- do nothing after fade out ends
            end))
        end))

end