-- 
-- StateMachine - a state machine (How to make an RPG)
--
-- Usage:
--
-- -- States are only created as needed, to save memory, reduce clean-up bugs
-- -- and increase speed due to garbage collection taking longer with more data
-- -- in memory.
-- --
-- -- States are added with a string identifier and a initialization function.
-- -- It expects that the init function, when called, will return a table with
-- -- Render, Update, Enter, and Exit methods.
--
-- gSM = StateMachine {
--    ['MainMenu'] = function()
--        return MainMenu()
--    end,
--    ['InnerGame'] = function()
--        return InnerGame()
--    end,
--    ['GameOver'] = function()
--        return GameOver()
--    end
-- }
-- gSM:change('MainMenu')
--
-- Arguments passed into the Change method after the state name will be 
-- forwarded to the Enter method of the destination state.
--
-- State identifiers should have the same name as the state table, unless
-- there's a good reason not to. (i.e. - MainMenu creates a state using the)
-- MainMenu table. This keeps things straight forward.

StateMachine = Class{}

function StateMachine:init(states)
    self.empty = {
        render = function() end,
        update = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.current = self.empty
end

function StateMachine:change(destinationState, enterArgs)
    assert(self.states[destinationState])
    self.current:exit()
    self.current = self.states[destinationState]()
    self.current:enter(enterArgs)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end