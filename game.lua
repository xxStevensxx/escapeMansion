local moduleGame = {}

local game_metaTable = {__index = moduleGame}


local char = require("character")
local const = require("const")
local util = require("utils")
local obj = require("object")

local listCharacters = char.list()
local listObject = obj.list()
local mainCharacter
local debug = false
local sndClone = util.sndClone()


function moduleGame.new() 

    local game = {}

    return setmetatable(game, game_metaTable)

end


function moduleGame.play()

   local game = moduleGame.new()
   
   for __, char in ipairs(listCharacters) do

        if char.type == const.TYPE.SOLDIER then

            mainCharacter = char

        end
        
   end

    function game:pause()
    end

    
    function game:spawner(nbMob)

        for m = 1, nbMob do

            local dice = math.random(1, 3)
            local nb = #const.TYPE
            local mob 

            if dice == 1 then

                mob = const.TYPE.ORC

            elseif dice == 2 then

                mob = const.TYPE.ORC_RIDER

            else

                mob = const.TYPE.ARMORED_SKELETON

            end

                char.create(mob)

        end


    end


    function game:animation(listCharacters, dt)

        for c = 1, #listCharacters do 

            local character = listCharacters[c]            
            if character.currentAnim == const.ANIM.DEAD then

                if not character.playedDeadAnim then

                    character.currentFrame = character.currentFrame + character.quad[character.currentAnim].animSpeed  * dt

                    if character.currentFrame >= character.quad[character.currentAnim].nbframe + 1 then

                        -- recupere la derniere frame de l'animation
                        character.currentFrame = character.quad[character.currentAnim].nbframe
                        character.playedDeadAnim = true

                    end
                    
                end

            else

                character.currentFrame = character.currentFrame + character.quad[character.currentAnim].animSpeed * dt
                
                if character.currentFrame >= character.quad[character.currentAnim].nbframe + 1 then
                    character.currentFrame = 1

                end

            end

        end

    end


    function game:life(character)

        local hearthWidth, hearthHeight = const.SPRITE.LEFT_HEART:getDimensions()
        local posX = _G.screenWidth - 400
        local posY = 30
    
        for pv = 1, character.hp do

            local impair = pv % 2 ~= 0

            if impair then

                love.graphics.draw(const.SPRITE.LEFT_HEART, posX , posY)

            else

                love.graphics.draw(const.SPRITE.RIGHT_HEART, posX, posY)

            end

            if impair == false then

                posX = posX + hearthWidth / 4

            end

        end
        
    end


    function game:mainCharacterAction()

        function pickUp()
            --TODO
        end


        function bowShoot()
            --TODO
        end


        function swordAttack()
            --TODO
        end


    end


    function game:controller(character, dt)

        if not character.isDead then

            if love.keyboard.isDown("up") then
                character.y = character.y - character.speed * dt
                character.currentAnim = const.ANIM.WALK
            else
                character.currentAnim = const.ANIM.IDLE
            end

            if love.keyboard.isDown("right") then
                character.currentAnim = const.ANIM.WALK
                character.x = character.x + character.speed * dt

            end

            if love.keyboard.isDown("down") then
                character.currentAnim = const.ANIM.WALK
                character.y = character.y + character.speed * dt

            end

            if love.keyboard.isDown("left") then
                character.currentAnim = const.ANIM.WALK
                character.x = character.x - character.speed * dt
            end

            if love.keyboard.isDown("a") then
                character.currentAnim = const.ANIM.ATTACK_ONE
            end


            if love.keyboard.isDown("z") then
                character.currentAnim = const.ANIM.ATTACK_TWO
            end


            if love.keyboard.isDown("b") then
                character.currentAnim = const.ANIM.ATTACK_THREE
            end

        end

    end


    function game:keypressed(key, character) 


        if key == "f1" then

            print(tostring(debug))
            print(key)
            debug = not debug

            return debug

        end
    end
        

    function game:drawCharacters(listCharacters, listObject)

        for c = 1, #listCharacters do

            local character = listCharacters[c]

            love.graphics.draw(character.spriteSheet, character.quad[character.currentAnim][math.floor(character.currentFrame)], character.x, character.y, 0, 3, 3, character.offsetX, character.offsetY)

        end

    end


    function game:debug(listCharacters)

        for c = 1, #listCharacters do 

            local character = listCharacters[c]

            if character.type ~= const.TYPE.SOLDIER then

                love.graphics.print(character.state, character.x, character.y + character.height / 2)
                love.graphics.print("vx: "..character.vX, character.x, character.y - character.height / 2)
                love.graphics.print("vy: "..character.vY, character.x, character.y - character.height )
                love.graphics.print(tostring(character.target), character.x, character.y + character.height)
                love.graphics.print(math.floor(character.currentFrame, 100, 100))
                love.graphics.setColor(0,1,0)
                love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 25, 0)
                love.graphics.setColor(1,1,1)


            end

                love.graphics.circle("line", character.x, character.y, character.vision)
                love.graphics.setColor(1,0,0)
                love.graphics.circle("line", character.x, character.y, character.range)
                love.graphics.setColor(1,1,1)
                love.graphics.rectangle("fill", character.x, character.y, 5, 5)
                love.graphics.print("cooldwon: "..tostring(character.cooldown), character.x + 20, character.y + 20)

        end

        for o = 1, #listObject do

            local object = listObject[o]

                love.graphics.circle("line", object.x, object.y, object.detectionRange)
                love.graphics.print("offX "..tostring(object.offsetX), object.x , object.y + 75)
                love.graphics.print("offY: "..tostring(object.offsetY), object.x, object.y + 35)
                love.graphics.print("widthIMG: "..tostring(object.image:getWidth()), object.x, object.y + 65)
                love.graphics.print("HEIGTHIMG: "..tostring(object.image:getHeight()), object.x, object.y + 95)



        end

    end

    return game

end


 function moduleGame.collider(character)

    local colision = false

    if character.x < 0 then

        character.x = 0
        colision = true

    end

    if character.x > _G.screenWidth then

        character.x = _G.screenWidth 
        colision = true

    end

    if character.y < 0 then

        character.y = 0
        colision = true

    end

    if character.y > _G.screenHeight  then
        
        character.y = _G.screenHeight
        colision = true

    end

    return colision

end


function moduleGame.keypressed(key)
    game:keypressed(key, mainCharacter)
end

function moduleGame.load()
    game = moduleGame.play()
    game:spawner(1)
    obj.load()
end

function moduleGame.update(dt)
    game:controller(mainCharacter, dt)
end

function moduleGame.draw()

    game:drawCharacters(listCharacters)
    obj.draw()
    obj.nextToObject(mainCharacter, listObject)
    game:life(mainCharacter)

    if debug == true then
        game:debug(listCharacters)
    end
    
end


return moduleGame




