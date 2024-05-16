
Console = Class{}

function Console:init(x, y)
    self.location = {['x'] = x, ['y'] = y}
    self.width = 320
    self.height = 200
    self.visible = false
    self.lineHeight = 8
    self.data = {
        '', '', '', '', '', ''
    }
end

function Console:logToSlot(index, message)
    if index > 0 and index < 7 then
        self.data[index] = message
    end
end

function Console:update(delta)
    if love.keyboard.wasPressed('c') then
        self.visible = not self.visible
    end
end

function Console:render()
    if self.visible then
        love.graphics.setFont(smallFont)
        for index, message in ipairs(self.data) do
            love.graphics.printf(
                message,
                self.location['x'],
                self.location['y'] + (index * self.lineHeight),
                VIRTUAL_WIDTH,
                'center'
            )
        end
    end
end