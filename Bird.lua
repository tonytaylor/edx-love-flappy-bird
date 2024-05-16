
Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- positions at center screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0

    self.ignoreCollisions = false
end

-- [[
--    AABB collision that expects a pipe, which will have an X and y
--    and reference global pipe width and height values
-- ]]
function Bird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- some leeway with the collision
    -- AABB bounding box collision detection test
    if self.ignoreCollisions == false then
        if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + PIPE_WIDTH then
            if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + PIPE_HEIGHT then
                return true
            end
        end
    end

    return false
end

function Bird:update(delta)
    -- the constant of gravity applied
    self.dy = self.dy + GRAVITY * delta

    -- anti-gravity (jumping)
    if love.keyboard.wasPressed('space') then
        self.dy = -3
        sounds['jump']:play()
    end

    if love.keyboard.wasPressed('x') then
        self.ignoreCollisions = not self.ignoreCollisions
    end

    self.y = self.y + self.dy
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end
