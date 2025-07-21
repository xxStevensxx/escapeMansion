local moduleQuadManager = {}

local quadManager_metaTable = {__index = moduleQuadManager}

local const = require("const")


-- Initialise les propriétés du quad en fonction du type (orc, soldat, etc.)
local function initializeType(quad, pType)

    local quadLine, quadColumn

    if pType == const.TYPE.ORC then

        quad.line = 8
        quad.column = 6

        quad.spriteSheet = const.SPRITE.ORC

        -- Assignation des animations aux indices
        quad.anim[0] = quad.anim.idle
        quad.anim[1] = quad.anim.walk
        quad.anim[2] = quad.anim.attack_one
        quad.anim[3] = quad.anim.attack_two
        quad.anim[4] = quad.anim.dammage
        quad.anim[5] = quad.anim.death

        -- Définition du nombre de frames pour chaque animation
        quad.anim.idle.nbframe = 6
        quad.anim.walk.nbframe = 8
        quad.anim.attack_one.nbframe = 6
        quad.anim.attack_two.nbframe = 6
        quad.anim.dammage.nbframe = 4
        quad.anim.death.nbframe = 4


        -- Vitesse d'animation égale au nombre de frames 
        quad.anim.idle.animSpeed = quad.anim.idle.nbframe
        quad.anim.walk.animSpeed = quad.anim.walk.nbframe
        quad.anim.attack_one.animSpeed = quad.anim.attack_one.nbframe
        quad.anim.attack_two.animSpeed = quad.anim.attack_two.nbframe
        quad.anim.dammage.animSpeed = quad.anim.dammage.nbframe
        quad.anim.death.animSpeed = quad.anim.death.nbframe


    elseif pType == const.TYPE.ORC_RIDER then

        quad.line = 11
        quad.column = 8

        quad.spriteSheet = const.SPRITE.ORC_RIDER

        quad.anim[0] = quad.anim.idle
        quad.anim[1] = quad.anim.walk
        quad.anim[2] = quad.anim.dash
        quad.anim[3] = quad.anim.attack_one
        quad.anim[4] = quad.anim.attack_two
        quad.anim[5] = quad.anim.guard
        quad.anim[6] = quad.anim.dammage
        quad.anim[7] = quad.anim.death


        quad.anim.idle.nbframe = 6
        quad.anim.walk.nbframe = 8
        quad.anim.dash.nbframe = 8
        quad.anim.attack_one.nbframe = 9
        quad.anim.attack_two.nbframe = 11
        quad.anim.guard.nbframe = 4
        quad.anim.dammage.nbframe = 4
        quad.anim.death.nbframe = 4

        quad.anim.idle.animSpeed =  quad.anim.idle.nbframe
        quad.anim.walk.animSpeed =  quad.anim.walk.nbframe
        quad.anim.dash.animSpeed =  quad.anim.dash.nbframe
        quad.anim.attack_one.animSpeed =  quad.anim.attack_one.nbframe
        quad.anim.attack_two.animSpeed =  quad.anim.attack_two.nbframe 
        quad.anim.guard.animSpeed =  quad.anim.guard.nbframe
        quad.anim.dammage.animSpeed =  quad.anim.dammage.nbframe
        quad.anim.death.animSpeed =  quad.anim.death.nbframe

    elseif pType == const.TYPE.SOLDIER then

        quad.line = 9
        quad.column = 7

        quad.spriteSheet = const.SPRITE.SOLDIER

        quad.anim[0] = quad.anim.idle
        quad.anim[1] = quad.anim.walk
        quad.anim[2] = quad.anim.attack_one
        quad.anim[3] = quad.anim.attack_two
        quad.anim[4] = quad.anim.attack_three
        quad.anim[5] = quad.anim.dammage
        quad.anim[6] = quad.anim.death


        quad.anim.idle.nbframe = 6
        quad.anim.walk.nbframe = 8
        quad.anim.attack_one.nbframe = 6
        quad.anim.attack_two.nbframe = 6
        quad.anim.attack_three.nbframe = 9
        quad.anim.dammage.nbframe = 4
        quad.anim.death.nbframe = 4

        quad.anim.idle.animSpeed = quad.anim.idle.nbframe
        quad.anim.walk.animSpeed = quad.anim.walk.nbframe
        quad.anim.attack_one.animSpeed = quad.anim.attack_one.nbframe
        quad.anim.attack_two.animSpeed = quad.anim.attack_two.nbframe
        quad.anim.attack_three.animSpeed = quad.anim.attack_three.nbframe
        quad.anim.dammage.animSpeed = quad.anim.dammage.nbframe
        quad.anim.death.animSpeed = quad.anim.death.nbframe

    elseif pType == const.TYPE.ARMORED_SKELETON then

        quad.line = 9
        quad.column = 6

        quad.spriteSheet = const.SPRITE.ARMORED_SKELETON

        quad.anim[0] = quad.anim.idle
        quad.anim[1] = quad.anim.walk
        quad.anim[2] = quad.anim.attack_one
        quad.anim[3] = quad.anim.attack_two
        quad.anim[4] = quad.anim.dammage
        quad.anim[5] = quad.anim.death


        quad.anim.idle.nbframe = 6
        quad.anim.walk.nbframe = 8
        quad.anim.attack_one.nbframe = 8
        quad.anim.attack_two.nbframe = 9
        quad.anim.dammage.nbframe = 4
        quad.anim.death.nbframe = 4

        quad.anim.idle.animSpeed = quad.anim.idle.nbframe
        quad.anim.walk.animSpeed = quad.anim.walk.nbframe
        quad.anim.attack_one.animSpeed = quad.anim.attack_one.nbframe
        quad.anim.attack_two.animSpeed = quad.anim.attack_two.nbframe
        quad.anim.dammage.animSpeed = quad.anim.dammage.nbframe
        quad.anim.death.animSpeed = quad.anim.death.nbframe

    else

        quad.line = 10
        quad.column = 10
        quad.spriteSheet = const.SPRITE.MANSION

    end

end

-- Crée un nouvel objet QuadManager avec ses propriétés initialisées
function moduleQuadManager.new()

    local quadManager = {

        x = 0,
        y = 0,
        widthQuad = 0,
        heightQuad = 0,
        line = 0,
        column = 0,
        spriteSheet = {},
        map = {} ,
        anim = {
            idle = {nbframe = 0, animSpeed = 0},
            walk = {nbframe = 0, animSpeed = 0},
            attack_one = {nbframe = 0, animSpeed = 0},
            attack_two = {nbframe = 0, animSpeed = 0},
            attack_three = {nbframe = 0, animSpeed = 0},
            dammage = {nbframe = 0, animSpeed = 0},
            death = {nbframe = 0, animSpeed = 0},
            dash = {nbframe = 0, animSpeed = 0},
            guard = {nbframe = 0, animSpeed = 0}
        }
        
    }

        -- Assigne les animations aux indices pour un accès facile
        quadManager.anim[0] = quadManager.anim.idle
        quadManager.anim[1] = quadManager.anim.walk
        quadManager.anim[2] = quadManager.anim.attack_one
        quadManager.anim[3] = quadManager.anim.attack_two
        quadManager.anim[4] = quadManager.anim.attack_three
        quadManager.anim[5] = quadManager.anim.dammage
        quadManager.anim[6] = quadManager.anim.death

    return setmetatable(quadManager, quadManager_metaTable)

end


-- Crée un quad pour un type donné en découpant la spritesheet en fonction des frames et animations
function moduleQuadManager.createQuad(pType)

    local quad = moduleQuadManager.new()

    -- Initialise les propriétés du quad selon le type (anim, spriteSheet, etc.)
    initializeType(quad, pType)

        local spriteWidth, spriteHeight = quad.spriteSheet:getDimensions()
        quad.widthQuad = spriteWidth / quad.line
        quad.heightQuad = spriteHeight / quad.column


        -- Parcours ligne/colonne pour créer les quads correspondant à chaque frame
        for spriteLine = 0, quad.line -1 do

            for spriteColumn = 0, quad.column -1 do

                if pType ~= const.MAP.MANSION then

                    -- Pour les personnages, on ajoute les quads dans la table d'animation correspondante
                    local qd = love.graphics.newQuad(spriteLine * quad.widthQuad, spriteColumn * quad.heightQuad, quad.widthQuad, quad.heightQuad, quad.spriteSheet:getDimensions())
                    table.insert(quad.anim[spriteColumn], qd)

                else

                    -- Pour la map, on stocke les quads dans une table map distincte
                    local qd = love.graphics.newQuad(spriteLine * quad.widthQuad , spriteColumn * quad.heightQuad, quad.widthQuad, quad.heightQuad, quad.spriteSheet:getDimensions())
                    table.insert(quad.map, qd)

                end

            end
  
        end

    return quad

end


return moduleQuadManager