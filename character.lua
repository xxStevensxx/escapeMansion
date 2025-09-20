local moduleCharacter = {}

local character_metaTable = {__index = moduleCharacter}

local quadMngr = require("quadManager")

local const = require("const")

local listCharacters = {main = 0}

-- Fonction pour créer un nouveau personnage avec des valeurs par défaut
function moduleCharacter.new()

    local character = {
        hp = 0,
        x = math.random(_G.screenWidth),
        y = math.random(_G.screenHeight),
        vX = 0,
        vY = 0,
        speed = 305,
        state = const.STATE.NONE,
        animSpeed = 0,
        width = 0,
        height = 0,
        angle = math.rad(0),
        offsetX = 0,
        offsetY = 0,
        type = nil,
        spriteSheet = nil,
        quad = {},
        currentFrame = 1,
        vision = 0,
        target = const.TARGET.NONE,
        currentAnim = const.ANIM.IDLE,
        watchDuration = nil,
        cooldown = 1,
        damageTimer = 10,
        dammageDuration = 0.5,
        isDead = false,
        playedDeadAnim = false
    }

    return setmetatable(character, character_metaTable)

end


-- Fonction de création d'un personnage selon son type (ex : SOLDIER, ORC)
function moduleCharacter.create(pType)

    local character = moduleCharacter.new()
    local qd = quadMngr.createQuad(pType)

    character.spriteSheet = qd.spriteSheet
    character.type = pType
    character.width = qd.widthQuad
    character.height = qd.heightQuad
    character.offsetX = character.width / 2
    character.offsetY = character.height / 2

    if pType == const.TYPE.SOLDIER then

        character.x = _G.worldWidth / 2
        character.y = _G.worldHeight / 2
        character.vision = 100 * _G.scale
        character.range = 19 * _G.scale
        character.hp = 100
        character.inventory = {}
        character.isBusy = false
        
    elseif pType == const.TYPE.ORC then

        character.vision = 80 * _G.scale
        character.range = 22 * _G.scale
        character.hp = 120
        character.speed = 90

    elseif pType == const.TYPE.ORC_RIDER then

        character.vision = 130 * _G.scale
        character.range = 35 * _G.scale
        character.hp = 275
        character.speed = 125


    elseif pType == const.TYPE.ARMORED_SKELETON then

        character.vision = 60 * _G.scale
        character.range = 25 * _G.scale
        character.hp = 200
        character.speed = 95

    end


    -- Chargement des animations dans la table quad
     for animName, anim in pairs(qd.anim) do

        character.quad[animName] = anim

    end 

    -- Ajout du personnage à la liste globale des personnages
    table.insert(listCharacters, character)
    

    return character

end


-- Fonction retournant la liste complète des personnages
function moduleCharacter.list()

    return listCharacters

end

-- Fonction de chargement (exemple : crée un soldat au démarrage)
function moduleCharacter.load()
    local soldier = moduleCharacter.create(const.TYPE.SOLDIER)
end


return moduleCharacter