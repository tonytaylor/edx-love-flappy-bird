
PlayingGame = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayingGame:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0
    self.limit = 2
    self.noise = .05
    self.score = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayingGame:update(dt)
    self.timer = self.timer + dt

    if self.timer > self.limit then
        -- -278, , 134
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y

        table.insert(self.pipePairs, PipePair(y))

        -- reset timer
        self.timer = 0
        -- add noise to and reset timer limit
        -- self.limit = self.limit + math.random(-(self.noise / 2), (self.noise / 2))
        self.limit = math.random(2 - (self.noise / 2), 2 + (self.noise / 2))
    end

    for k, pair in pairs(self.pipePairs) do

        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
                sounds['score']:play()
            end
        end
        -- update position of pair
        pair:update(dt)
    end

    for k, pair in pairs(self.pipePairs) do
        if pair.remove then
            table.remove(self.pipePairs, k)
        end
    end

    self.bird:update(dt)

    for k, pair in pairs(self.pipePairs) do
        for j, pipe in pairs(pair.pipes) do
            if self.bird:collides(pipe) then
                --gameSM:change('title')
                sounds['explosion']:play()
                sounds['hurt']:play()
                gameSM:change('score', { score = self.score })
            end
        end
    end

    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        --gameSM:change('title')
        sounds['explosion']:play()
        sounds['hurt']:play()
        gameSM:change('score', { score = self.score })
    end
end

function PlayingGame:render()
    local pairUpper = ''
    local pairLower = ''
    for k, pair in pairs(self.pipePairs) do
        pair:render()
        pairLower = 'Lower Pipe: ' .. pair.pipes['lower'].y
        pairUpper = 'Upper Pipe: ' .. pair.pipes['upper'].y
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
    console:logToSlot(2, 'Collisions off: ' .. tostring(self.bird.ignoreCollisions))
    console:logToSlot(3, 'Current timer limit: ' .. tostring(self.limit))
    print('Current timer limit: ' .. tostring(self.limit))
    print('Lower pipe Y: ' .. pairLower .. ', ' .. 'Upper pipe Y: ' .. pairUpper)
    console:logToSlot(4, pairLower .. ', ' .. pairUpper)

    self.bird:render()
end