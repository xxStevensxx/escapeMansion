    local modulMainCharAction = {}

    local mainCharacterAction_metaTable = {__index = modulMainCharAction}

    -- local characters = require("character")
    local const = require("const")
    local util = require("utils")

    local listArrows = {}

    function modulMainCharAction.new()

        local mainCharacterAction = {}

        return setmetatable(mainCharacterAction, mainCharacterAction_metaTable)

    end


    function modulMainCharAction.shoot(listCharacters, mainCharacter)
        
        if mainCharacter.cooldown > 0 then return end
                    const.SOUND.BOW_SHOOT:play()


        for character = 1, #listCharacters do

            local target = listCharacters[character]
            local angle

            if target.type ~= const.TYPE.SOLDIER then

                local distance = math.dist(mainCharacter.x, mainCharacter.y, target.x, target.y)

                if distance <= mainCharacter.vision then

                    local angle = math.angle(mainCharacter.x, mainCharacter.y, target.x, target.y)

                    local arrow = {

                        x = mainCharacter.x,
                        y = mainCharacter.y,
                        angle = angle,
                        speed = 800,
                        image = const.SPRITE.ARROW

                    }

                    table.insert(listArrows, arrow)
                    

                end

            end

        end

            mainCharacter.cooldown = 0.8
        
    end


    function modulMainCharAction.slash()
    end

    function modulMainCharAction.load()
        modulMainCharAction.new()
    end

    function modulMainCharAction.update(listCharacters, mainCharacter, dt)

        if mainCharacter.cooldown > 0 then

             mainCharacter.cooldown = util.timer(mainCharacter.cooldown, dt)

        end

        for arrowIndex = #listArrows, 1, -1 do

            local arrow = listArrows[arrowIndex]

            local vX = (arrow.speed * dt) * math.cos(arrow.angle)
            local vY = (arrow.speed * dt) * math.sin(arrow.angle)

            arrow.x = arrow.x  + vX
            arrow.y = arrow.y  + vY

            if arrow.x < 0 or arrow.x > _G.screenWidth or arrow.y < 0 or arrow.y > _G.screenHeight then

                table.remove(listArrows, arrowIndex)

            end

            for character = 1, #listCharacters do

                local target = listCharacters[character]

                if target.type ~= const.TYPE.SOLDIER then

                    local distance = math.dist(arrow.x, arrow.y, target.x, target.y)

                    if distance < 5 and not target.isDead then

                        target.state = const.STATE.DAMMAGE
                        table.remove(listArrows, arrowIndex)

                    end

                end

            end

        end
        
        
    end

    function modulMainCharAction.draw()

        for arrow = 1, #listArrows do

            local arrow = listArrows[arrow]

            love.graphics.draw(arrow.image, arrow.x, arrow.y, arrow.angle, _G.scale, _G.scale, arrow.image:getWidth() / 2, arrow.image:getHeight() / 2)
            
        end

    end


    return modulMainCharAction



 