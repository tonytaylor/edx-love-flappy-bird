
--[[
    PipePair Class

    Used to represent a pair of pipes that stick together as they scroll,
    providing an opening for the player to jump through in order to score
    a point.
]]

PipePair = Class{}

-- size of the (vertical) gap between pipes
local GAP_HEIGHT = 90

function PipePair:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y

    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- flag indicating ready for removal
    self.remove = false

    -- flag indicating pair has been scored
    self.scored = false
end

function PipePair:update(dt)
    -- remove the pipe from the scene if it's beyond the left edge of the
    -- screen, otherwise, move from right to left
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes['lower'].x = self.x
        self.pipes['upper'].x = self.x
    else
        self.remove = true
    end
end

function PipePair:render()
    for key, pipe in pairs(self.pipes) do
        pipe:render()
    end
end