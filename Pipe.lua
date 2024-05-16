Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('pipe.png')
local PIPE_SCROLL = -60

PIPE_SPEED = 60

-- dimensions of pipe image, globally accessible
PIPE_HEIGHT = 288
PIPE_WIDTH = 70

function Pipe:init(orientation, y)
    self.x = VIRTUAL_WIDTH
    self.y = y

    -- setting Y to a random value halfway below the screen
    --self.y = math.random(VIRTUAL_HEIGHT / 4, VIRTUAL_HEIGHT - 10)

    self.width = PIPE_IMAGE:getWidth()
    self.height = PIPE_HEIGHT

    self.orientation = orientation
end

function Pipe:update(delta)
    self.x = self.x + PIPE_SCROLL * delta
end

function Pipe:render()
    --love.graphics.draw(PIPE_IMAGE, math.floor(self.x + 0.5), math.floor(self.y))
    -- local y1 = self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y
    
    love.graphics.draw(PIPE_IMAGE, self.x,
        (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y),
        0, -- rotation
        1, -- X scale
        self.orientation == 'top' and -1 or 1) -- Y scale
end