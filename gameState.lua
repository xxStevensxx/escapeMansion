local moduleGameState = {}

local gameState_metaTable = {__index = moduleGameState}


local const = require("const")
local services = require("services")


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
    local grp = nil
    
    -- Affiche le groupe GUI du menu "started" si l'état courant est STARTED
    function gameState:started()

        services.gui.hideGroupe()

         grp = services.gui.getGroup("startedGroup")

        if self.currentState == const.GAME_STATE.STARTED then

            grp:setVisible(true)

        end

    end

    -- Placeholder pour l'état "play"
    function gameState:play()

        services.gui.hideGroupe()  

        grp = services.gui.getGroup("playGroup")
        
        if self.currentState == const.GAME_STATE.PLAY then

            grp:setVisible(true)

        end

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

-- instancie et charge le GUI
function moduleGameState.load()
    gs = moduleGameState.state()
end

-- Met à jour le GUI et les états du jeu chaque frame
function moduleGameState.update(dt)

    gs:started()
    gs:play()

end



return moduleGameState