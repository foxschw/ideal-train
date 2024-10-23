--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

LevelUpMenuState = Class{__includes = BaseState}

function LevelUpMenuState:init(battleState, exp)
    self.battleState = battleState
    self.exp = exp
    self.HPIncrease, self.attackIncrease, self.defenseIncrease, self.speedIncrease = self.battleState.playerPokemon:levelUp()
    
    self.levelUpMenu = Menu {
        x = 0,
        y = VIRTUAL_HEIGHT - 64,
        width = VIRTUAL_WIDTH,
        height = 64,
        font = gFonts['small'],
        items = {
            {
                text = ('XP: ' .. self.battleState.playerPokemon.currentExp .. ' + ' .. self.exp .. ' = ' .. self.battleState.playerPokemon.currentExp + self.exp)
                -- onSelect = function()
                --     gStateStack:pop()
                --     gStateStack:push(TakeTurnState(self.battleState))
                -- end
            },
            {
                text = ('Attack: ' .. self.battleState.playerPokemon.attack .. ' + ' .. self.attackIncrease .. ' = ' .. self.battleState.playerPokemon.attack + self.attackIncrease)
            },
            {
                text = ('Defense: ' .. self.battleState.playerPokemon.defense .. ' + ' .. self.defenseIncrease .. ' = ' .. self.battleState.playerPokemon.defense + self.defenseIncrease)
            },
            {
                text = ('Speed: ' .. self.battleState.playerPokemon.speed .. ' + ' .. self.speedIncrease .. ' = ' .. self.battleState.playerPokemon.speed + self.speedIncrease)
            }
            -- {
            --     text = 'Run',
            --     onSelect = function()
            --         gSounds['run']:play()
                    
            --         -- pop battle menu
            --         gStateStack:pop()

            --         -- show a message saying they successfully ran, then fade in
            --         -- and out back to the field automatically
            --         gStateStack:push(BattleMessageState('You fled successfully!',
            --             function() end), false)
            --         Timer.after(0.5, function()
            --             gStateStack:push(FadeInState({
            --                 r = 1, g = 1, b = 1
            --             }, 1,
                        
            --             -- pop message and battle state and add a fade to blend in the field
            --             function()

            --                 -- resume field music
            --                 gSounds['field-music']:play()

            --                 -- pop message state
            --                 gStateStack:pop()

            --                 -- pop battle state
            --                 gStateStack:pop()

            --                 gStateStack:push(FadeOutState({
            --                     r = 1, g = 1, b = 1
            --                 }, 1, function()
            --                     -- do nothing after fade out ends
            --                 end))
            --             end))
            --         end)
            --     end
            -- }
        }
    }
end

function LevelUpMenuState:update(dt)
    self.levelUpMenu:update(dt)
end

function LevelUpMenuState:render()
    self.levelUpMenu:render()
end