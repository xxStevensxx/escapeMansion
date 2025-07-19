local moduleCharacter = {}

local character_metaTable = {__index = moduleCharacter}

local quadMngr = require("quadManager")

local const = require("const")

local listCharacters = {}

function moduleCharacter.new()

    local character = {
        hp = 0,
        x = math.random(_G.screenWidth),
        y = math.random(_G.screenHeight),
        vX = 0,
        vY = 0,
        speed = 200,
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
        cooldown = 0.8,
        damageTimer = 10,
        isDead = false,
        playedDeadAnim = false
    }

    return setmetatable(character, character_metaTable)

end


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

        character.vision = 100
        character.range = 55
        character.hp = 100
        character.inventory = {}
        -- character.speed = 100

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


     for animName, anim in pairs(qd.anim) do

        character.quad[animName] = anim

    end 

    if character.type ~= const.TYPE.SOLDIER then

        character.state = const.STATE.NONE
    end

    table.insert(listCharacters, character)
    return character

end



function moduleCharacter.list()

    return listCharacters

end

function moduleCharacter.load()
    local soldier = moduleCharacter.create(const.TYPE.SOLDIER)
end

function moduleCharacter.draw()
end


return moduleCharacter