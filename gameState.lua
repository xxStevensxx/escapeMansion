local moduleGameState = {}

local gameState_metaTable = {__index = moduleGameState}


local const = require("const")
local gui = require("gui")
local gs


function moduleGameState.new()

    local gameState = {
        currentState = const.GAME_STATE.STARTED
    }

    return  setmetatable(gameState, gameState_metaTable)

end


function moduleGameState.state()

    local gameState = moduleGameState.new()


    function gameState:started()

        started = gui.getStartedGroup()

        if gs.currentState == const.GAME_STATE.STARTED then

            started:setVisible(true)

        else

            started:setVisible(false)

        end


    end

    function gameState:play()
        

    end


    function gameState:pause()
    end


    function gameState:restart()
    end


    function gameState:quit()
    end


    function gameState:gameover()
    end

return gameState

end

function moduleGameState.getInstance()

    return gs

end

function moduleGameState.load()
    gui.load()
    gs = moduleGameState.state()
end


function moduleGameState.update(dt)
    gui.update(dt)
    gs:started()
    gs:pause()
    gs:restart()
    gs:quit()
    gs:gameover()
end


function moduleGameState.draw()
    gui.draw()
end



return moduleGameState