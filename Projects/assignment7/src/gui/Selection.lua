--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Selection class gives us a list of textual items that link to callbacks;
    this particular implementation only has one dimension of items (vertically),
    but a more robust implementation might include columns as well for a more
    grid-like selection, as seen in many kinds of interfaces and games.
]]

Selection = Class{}

function Selection:init(def)
    self.items = def.items
    self.x = def.x
    self.y = def.y

    self.height = def.height
    self.width = def.width
    self.font = def.font or gFonts['small']

    -- pass in the type, use 'choice' as default type
    self.type = def.type or 'choice'

    -- for display type menu, reduce the gapHeight slightly to fit better in the panel
    if self.type == 'display' then
        self.gapHeight = (self.height / #self.items) / 1.15
    else
        self.gapHeight = self.height / #self.items
    end

    self.currentSelection = 1

end

function Selection:update(dt)
    -- run selection logic if the type is 'choice'
    if self.type == 'choice' then
        if love.keyboard.wasPressed('up') then
            if self.currentSelection == 1 then
                self.currentSelection = #self.items
            else
                self.currentSelection = self.currentSelection - 1
            end
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        elseif love.keyboard.wasPressed('down') then
            if self.currentSelection == #self.items then
                self.currentSelection = 1
            else
                self.currentSelection = self.currentSelection + 1
            end
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        elseif love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
            self.items[self.currentSelection].onSelect()
            
            gSounds['blip']:stop()
            gSounds['blip']:play()
        end
    else
        -- the only other type is display, run onSelect if user presses enter or space 
        -- (behaves similar to messages)
        if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('space') then
            self.items[self.currentSelection].onSelect()
        end
    end
end

function Selection:render()
    local currentY = self.y

    for i = 1, #self.items do
        local paddedY = currentY + (self.gapHeight / 2) - self.font:getHeight() / 2

        -- only render the cursor if the type is 'choice'
        if self.type == 'choice' then
            -- draw selection marker if we're at the right index
            if i == self.currentSelection then
                love.graphics.draw(gTextures['cursor'], self.x - 8, paddedY)
            end
        end

        love.graphics.printf(self.items[i].text, self.x, paddedY, self.width, 'center')

        currentY = currentY + self.gapHeight
    end
end