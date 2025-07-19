local moduleObject = {}

local object_metaTable = {__index = moduleObject}

local listObjects = {}

local const = require("const")


function moduleObject.new()

        local object = {
            x = math.random(_G.screenWidth),
            y = math.random(_G.screenHeight),
            offsetX = nil,
            offsetY = nil,
            type = nil,
            image = {},
            projectile = { image = {}, nb = 0},
            detectionRange = 35,
            pickUp = false
        }

        return setmetatable(object, object_metaTable)
end


function moduleObject.create(obj)

    local object = moduleObject.new()


       if obj == const.OBJECT.BOW then

            object.image = const.SPRITE.BOW
            object.projectile.image = const.SPRITE.ARROW
            object.projectile.nb = 10
            object.type = obj
            object.offsetX = object.image:getWidth() / 2
            object.offsetY = object.image:getHeight() / 2

        end 

        if obj == const.OBJECT.SWORD then

            object.image = const.SPRITE.SWORD
            object.type = obj
            object.offsetX = object.image:getWidth() / 2
            object.offsetY = object.image:getHeight() / 2

        end 

    
        table.insert(listObjects, object)

    return object

end


function moduleObject.list()
    return listObjects
end

local function pickUp(character, object)

    if love.keyboard.isDown("e") then

        object.pickUp = true
        table.insert(character.inventory, object)
        const.SOUND.EQUIP:play()
        
    end

end


function moduleObject.nextToObject(character, listObject)

        for o = 1, #listObject do
        
        if character.type == const.TYPE.SOLDIER then

            local object = listObject[o]
            local distance = math.dist(character.x, character.y, object.x, object.y)

            if distance < object.detectionRange and not object.pickUp then

                love.graphics.print("press E to pick up", character.x, character.y - 35)
                pickUp(character, object)

            end
            
        end
        
    end

end


function moduleObject.drawObject(listObject)

    for o = 1, #listObject do

        local object = listObject[o]

        if not object.pickUp then

            love.graphics.draw(object.image, object.x, object.y, 0, 1, 1, object.offsetX, object.offsetY)

        end

    end

end


function moduleObject.load()
    local bow = moduleObject.create(const.OBJECT.BOW)
    local sword = moduleObject.create(const.OBJECT.SWORD)

end

function moduleObject.update(dt)
end


function moduleObject.draw()
    moduleObject.drawObject(listObjects)
end

return moduleObject



