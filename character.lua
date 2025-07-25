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
        speed = 400,
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

        character.vision = 350
        character.range = 55
        character.hp = 100
        character.inventory = {}
        character.isBusy = false
        
    elseif pType == const.TYPE.ORC then

        character.vision = 100
        character.range = 60
        character.hp = 150
        character.speed = 110

    elseif pType == const.TYPE.ORC_RIDER then

        character.vision = 160
        character.range = 100
        character.hp = 450
        character.speed = 100


    elseif pType == const.TYPE.ARMORED_SKELETON then

        character.vision = 60
        character.range = 80
        character.hp = 200
        character.speed = 80

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