local moduleGame = {}

local game_metaTable = {__index = moduleGame}


local char = require("character")
local const = require("const")
local util = require("utils")
local obj = require("object")
local mainCharAction = require("mainCharAction")
local gameState = require("gameState")
local services = require("services")

-- Liste des personnages et objets existants dans le jeu
local listCharacters = char.list()
local listObject = obj.list()
local mainCharacter
local debug = false
local sndClone = util.sndClone()


-- Crée une nouvelle instance de jeu
function moduleGame.new() 

    local game = {}

    return setmetatable(game, game_metaTable)

end


-- Lance la partie et retourne l’objet game avec ses méthodes
function moduleGame.play()

   local game = moduleGame.new()
   
    -- Recherche le personnage principal (soldier) dans la liste
   for __, char in ipairs(listCharacters) do

        if char.type == const.TYPE.SOLDIER then

            mainCharacter = char

        end
        
   end


   -- Placeholder pour état "started" du jeu
   function game:started()

    -- TODO

   end

   -- Placeholder pour pause du jeu
    function game:pause()

        --TODO
        
    end


    -- Fonction de spawn aléatoire de mobs
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

   -- Mise à jour de l’animation pour tous les personnages
    function game:animation(listCharacters, dt)

        for c = 1, #listCharacters do 

            local character = listCharacters[c]            
            if character.currentAnim == const.ANIM.DEAD then

                if not character.playedDeadAnim then

                    character.currentFrame = character.currentFrame + character.quad[character.currentAnim].animSpeed  * dt

                    if character.currentFrame >= character.quad[character.currentAnim].nbframe + 1 then

                        -- Dernière frame de l'animation mort affichée
                        character.currentFrame = character.quad[character.currentAnim].nbframe
                        character.playedDeadAnim = true

                    end
                    
                end

            else

                -- Animation boucle normalement
                character.currentFrame = character.currentFrame + character.quad[character.currentAnim].animSpeed * dt
                
                if character.currentFrame >= character.quad[character.currentAnim].nbframe + 1 then
                    character.currentFrame = 1

                end

            end

        end

    end

    -- Contrôle du personnage principal avec les touches
    function game:controller(character, dt)

        -- Ne pas rien faire d'autre si le personnage est occupé dans une action
        if character.isBusy then

                character.cooldown = util.timer(character.cooldown, dt)

                if character.cooldown <= 0 then

                    character.isBusy = false
                    character.currentAnim = const.ANIM.IDLE

                end

            return -- bloquer les mouvements pendant l’attaque

        end

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


        end

    end

   -- Gestion des touches pressées
    function game:keypressed(key, character) 


        if key == "f1" then

            print(tostring(debug))
            print(key)
            debug = not debug

            return debug
        end

        if key == "b" and not character.isBusy  then
                
                for weapon = 1, #character.inventory do

                    local weapon = character.inventory[weapon].type

                    if weapon == const.OBJECT.BOW then

                        character.isBusy = true
                        character.cooldown = 1

                        character.currentAnim = const.ANIM.ATTACK_THREE
                        mainCharAction.shoot(listCharacters, mainCharacter, dt)
                        break


                    end

                end

            end



        if gs.currentState == const.GAME_STATE.STARTED then

            if key then

                gs.currentState = const.GAME_STATE.PLAY 
                gs:play()

            end

        end


        if key == "escape" then

            gs.currentState = const.GAME_STATE.PAUSE
            gs:pause()

        end

    end
        
   -- Affiche tous les personnages
    function game:drawCharacters(listCharacters, listObject)

        for c = 1, #listCharacters do

            local character = listCharacters[c]

            love.graphics.draw(character.spriteSheet, character.quad[character.currentAnim][math.floor(character.currentFrame)], character.x, character.y, 0, _G.scale, _G.scale, character.offsetX, character.offsetY)

        end

    end

   -- Affichage debug (informations détaillées)
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
                love.graphics.print("cooldown: "..tostring(character.cooldown), character.x + 20, character.y + 20)
                love.graphics.print("dammageDur: "..tostring(character.dammageDuration), character.x + 30, character.y + 30)
                love.graphics.print("HP : "..tostring(character.hp), character.x , character.y - 150)



        end

        for o = 1, #listObject do

            local object = listObject[o]

                love.graphics.circle("line", object.x, object.y, object.detectionRange)
                love.graphics.print("offX "..tostring(object.offsetX), object.x , object.y + 75)
                love.graphics.print("offY: "..tostring(object.offsetY), object.x, object.y + 35)
                love.graphics.print("widthIMG: "..tostring(object.image:getWidth()), object.x, object.y + 65)
                love.graphics.print("HEIGTHIMG: "..tostring(object.image:getHeight()), object.x, object.y + 95)



        end

        local mansion = require("mansion")
        local mansion_map = require("mansion_map")
        
        local listRooms = mansion.getListRooms()


        
        for room = 1, #listRooms do
            
            for row = 1, #listRooms[room].grid do

                local size = mansion_map.sizeGrid(listRooms[room].grid)
                local mapWidth = size.width * 16 * _G.scale
                local mapHeight = size.height * 16 * _G.scale

                local offsetX = (listRooms[room].column - 1) * mapWidth
                
                for column = 1, #listRooms[room].grid[row] do
                    
                    local offsetY = (listRooms[room].row - 1) * mapHeight

                    local tileID = listRooms[room].grid[row][column]

                    -- love.graphics.print(tileID,  column * 16 * _G.scale, row * 16 * _G.scale, 0)
                    love.graphics.print(tileID, offsetX + (column - 1) * 16 * _G.scale,  offsetY + (row - 1) * 16 * _G.scale, 0)


                end

            end


        end

    end

    return game

end

-- Gestion des collisions avec les bords de l’écran apres a gerer avec les tuiles 
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

-- Fonction pour centrer la caméra sur le personnage principal
function moduleGame.camera()
    
    local cam = {
        x = 0,
        y = 0
    }

    cam.x = mainCharacter.x - _G.screenWidth / 2
    cam.y = mainCharacter.y - _G.screenHeight / 2

    love.graphics.translate(-cam.x, -cam.y)

end

-- utile pour le gui vie inventaire etc
function moduleGame.getMainCharacter()

    return mainCharacter

end


function moduleGame.keypressed(key)
    game:keypressed(key, mainCharacter)
end

-- Chargement initial du jeu
function moduleGame.load()
    -- const.SOUND.MUSIC:setLooping(true)
    -- const.SOUND.MUSIC:play()
    gameState.load()
    game = moduleGame.play()
    game:spawner(3)
    obj.load()
    mainCharAction = mainCharAction.new()

end

-- Mise à jour du jeu à chaque frame
function moduleGame.update(dt)
    gameState.update(dt)
    game:controller(mainCharacter, dt)
    mainCharAction.update(listCharacters, mainCharacter, dt)
end

-- Dessin de tous les éléments du jeu à chaque frame
function moduleGame.draw()
    game:drawCharacters(listCharacters)
    obj.draw()
    obj.nextToObject(mainCharacter, listObject)
    mainCharAction.draw()

    if debug == true then
        game:debug(listCharacters)
    end
    
end


return moduleGame




