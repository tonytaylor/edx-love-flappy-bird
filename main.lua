--[[
    GD50
    Flappy Bird Remake

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move slightly
    upwards. A variant of popular games like "Helicopter Game" that floated around
    the Internet for years prior. This illustrates some of the most basic procedural
    generation of game levels possible as by having pipes stick out of the ground by
    varying amounts, acting as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'
-- OOP class library
Class = require 'class'
-- player character
require 'Bird'
-- game obstacle
require 'Pipe'
-- group of pipes
require 'PipePair'
-- console attempt
require 'Console'

-- state / state machine
require 'StateMachine'
require 'states.BaseState'
require 'states.ShowingTitle'
require 'states.PlayingGame'
require 'states.ShowingScore'
require 'states.CountingDown'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

local BKGD_SCROLL_SPEED = 30
local GD_SCROLL_SPEED = 90

local BKGD_LOOP_POINT = 413

local bkgd = love.graphics.newImage('background.png')
local bkgd_scroll = 0
local gd = love.graphics.newImage('ground.png')
local gd_scroll = 0

local game_paused = false

local bird = Bird()

-- table for tracking spawned Pipes
local pipePairs = {}

-- index for tracking spawned Pipes
local spawnTimer = 0

-- initialize our last recorded Y value for a gap placement to base other gaps off of
local lastY = -PIPE_HEIGHT + math.random(80) + 20

-- used to pause the game when colliding with a pipe
local scrolling = true

function love.load()
    -- initialize the nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seeding RNG
    --math.randomseed(os.time())

    -- application window title
    love.window.setTitle('50 Bird')

    --initialize text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    sounds['music']:setLooping(true)
    sounds['music']:play()

    -- initialize virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    gameSM = StateMachine({
        ['title'] = function() return ShowingTitle() end,
        ['countdown'] = function() return CountingDown() end,
        ['play'] = function() return PlayingGame() end,
        ['score'] = function() return ShowingScore() end
    })

    gameSM:change('title')

    love.keyboard.keysPressed = {}

    console = Console(0, 220)
    console:logToSlot(1, 'console active.')
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    elseif key == 'p' then
        game_paused = not game_paused
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    if not game_paused then
        if not sounds['music']:isPlaying() then
            sounds['music']:play()
        end
        -- Adds global scroll speed const * delta for time-independent updates.
        -- Also uses modulo to calculate an offset.  the BKGD_LOOP_POINT is the
        -- coordinate on the x-axis that maintain the illusion of continuity

        -- scroll background by preset speed * dt, looping back to 0 after the looping point
        bkgd_scroll = (bkgd_scroll + BKGD_SCROLL_SPEED * dt) % BKGD_LOOP_POINT
        -- scroll ground by preset speed * dt, looping back to 0 after the passing the screen's width
        gd_scroll = (gd_scroll + GD_SCROLL_SPEED * dt) % VIRTUAL_WIDTH

        gameSM:update(dt)
        console:update(dt)
    else
        sounds['music']:pause()
    end

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    love.graphics.draw(bkgd, -bkgd_scroll, 0)
    gameSM:render()
    console:render()
    love.graphics.draw(gd, -gd_scroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end