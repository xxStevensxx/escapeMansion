local moduleGameState = {}

local gameState_metaTable = {__index = moduleGameState}


local const = require("const")
local gui = require("gui")
local gs -- singleton instance du gameState


-- Crée une nouvelle instance de gameState avec état initial
function moduleGameState.new()

    local gameState = {
        currentState = const.GAME_STATE.STARTED
    }

    return  setmetatable(gameState, gameState_metaTable)

end

-- Initialise les différentes fonctions associées aux états du jeu
function moduleGameState.state()

    local gameState = moduleGameState.new()


    -- Affiche le groupe GUI du menu "started" si l'état courant est STARTED
    function gameState:started()

        started = gui.getStartedGroup()

        if gs.currentState == const.GAME_STATE.STARTED then

            started:setVisible(true)

        else

            started:setVisible(false)

        end


    end

    -- Placeholder pour l'état "play"
    function gameState:play()
        
        -- TODO

    end

    -- Placeholder pour l'état "pause"
    function gameState:pause()

        --TODO

    end

    -- Placeholder pour l'état "restart"
    function gameState:restart()

        --TODO

    end


    -- Placeholder pour quitter le jeu
    function gameState:quit()

        --TODO

    end

    -- Placeholder pour état game over
    function gameState:gameover()

        --TODO

    end

return gameState

end

-- Retourne l'instance singleton du gameState
function moduleGameState.getInstance()

    return gs

end

-- Met à jour le GUI et les états du jeu chaque frame
function moduleGameState.load()
    gui.load()
    gs = moduleGameState.state()
end

-- Met à jour le GUI et les états du jeu chaque frame
function moduleGameState.update(dt)
    gui.update(dt)
    gs:started()
    gs:pause()
    gs:restart()
    gs:quit()
    gs:gameover()
end

-- Dessine le GUI
function moduleGameState.draw()
    gui.draw()
end



return moduleGameState