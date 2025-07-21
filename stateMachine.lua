local moduleStateMachine = {}

local moduleStateMachine_metaTable = {__index = moduleStateMachine}

local const = require("const")
local char = require("character")
local g = require("game")
local game = g.play()
local util = require("utils")



local stateMachine

function moduleStateMachine.new()

    local stateMachine = {
        listCharacters = char.list()
    }

    return setmetatable(stateMachine, moduleStateMachine_metaTable)
end


function moduleStateMachine.run()
    
    local stateMachine = moduleStateMachine.new()

    function stateMachine:state(dt)

        local anim = nil
        local mainCharacter = nil

        for __, character in ipairs(self.listCharacters) do 
            if character.type == const.TYPE.SOLDIER then mainCharacter = character end
        end
        
        for c = 1, #self.listCharacters do
            
            local character = self.listCharacters[c]
            local colision = game.collider(character)

            local distance = math.dist(character.x, character.y, mainCharacter.x, mainCharacter.y)

            -- aucun etat
            if character.state == const.STATE.NONE and character.type ~= const.TYPE.SOLDIER then
                

                if mainCharacter.isDead == false then

                    character.angle = math.angle(character.x, character.y, math.random(_G.screenWidth), math.random(_G.screenHeight))
                    character.state = const.STATE.WALK

                else

                    character.x = character.x
                    character.y = character.y
                    character.vX = 0
                    character.vY = 0

                end


            end

            -- etat marche
            if character.state == const.STATE.WALK and character.type ~= const.TYPE.SOLDIER then

                character.currentAnim = const.ANIM.WALK

                character.vX = character.speed * math.cos(character.angle)
                character.vY = character.speed * math.sin(character.angle)

                character.x = character.x + character.vX * dt
                character.y = character.y + character.vY * dt

                if colision then character.state = const.STATE.CHANGEDIR end

                if distance < character.vision then

                    character.state = const.STATE.PURSUIT

                end

            end

            -- change de direction apres colision
            if character.state == const.STATE.CHANGEDIR and character.type ~= const.TYPE.SOLDIER then

                character.currentAnim = const.ANIM.WALK

                character.angle = math.angle(character.x, character.y, math.random(_G.screenWidth), math.random(_G.screenHeight))
                character.state = const.STATE.WALK

            end

            -- poursuit le joueur afin de l'attaquer
            if character.state == const.STATE.PURSUIT and character.type ~= const.TYPE.SOLDIER then

                character.target = mainCharacter
                character.currentAnim = const.ANIM.WALK                
                
                character.angle = math.angle(character.x, character.y, character.target.x, character.target.y)
                character.vX = character.speed * math.cos(character.angle)
                character.vY = character.speed * math.sin(character.angle)

                character.x = character.x + character.vX * dt
                character.y = character.y + character.vY * dt


                if distance > character.vision then

                character.state = const.STATE.SEARCH
                character.target = const.TARGET.NONE

                end


                if distance < character.range then

                    character.state = const.STATE.ATTACK

                end

            end

            -- a perdu de vu l'ennemi et le cherche
            if character.state == const.STATE.SEARCH then
                
                if character.watchDuration == nil then
                    
                    character.watchDuration = math.random(2, 4)

                end

                character.currentAnim = const.ANIM.IDLE

                character.x = character.x
                character.y = character.y
                currentVision = character.vision

                character.watchDuration = util.timer(character.watchDuration , dt)

                if character.watchDuration <= 0 then

                    character.state = const.STATE.WALK
                    character.watchDuration = nil

                end

                if distance <= character.vision then

                    character.state = const.STATE.PURSUIT

                end

            end

            local initaleCooldown = character.cooldown

            if character.state == const.STATE.ATTACK and character.target then

                character.cooldown = util.timer(character.cooldown, dt)

                if distance < character.range / 2 then

                    if character.cooldown <= 0 then

                        character.currentAnim = const.ANIM.ATTACK_TWO
                        mainCharacter.currentAnim = const.ANIM.DAMMAGE                        
                        mainCharacter.hp = mainCharacter.hp - 14
                        const.SOUND.DAMMAGE_FOUR:play()

                        character.cooldown = 1

                    end


                elseif distance <= character.range then
                    
                    character.cooldown = util.timer(character.cooldown, dt)

                    if character.cooldown <= 0 then
                        
                        mainCharacter.damageTimer = util.timer(mainCharacter.damageTimer, dt)
                        
                        character.currentAnim = const.ANIM.ATTACK_ONE
                        mainCharacter.currentAnim = const.ANIM.DAMMAGE
                        mainCharacter.hp = mainCharacter.hp - 7
                        const.SOUND.DAMMAGE_FIVE:play()

                        character.cooldown = 1
                        
                        
                    end

                        mainCharacter.currentAnim = const.ANIM.DAMMAGE

                else

                    character.state = const.STATE.PURSUIT

                end

                if distance > character.vision then

                    character.state = const.STATE.SEARCH

                end
             
            end


            if character.state == const.STATE.DAMMAGE then

                character.currentAnim = const.ANIM.DAMMAGE
                character.dammageDuration = util.timer(character.dammageDuration, dt)
                
                if character.dammageDuration <= 0 then
                    
                    character.state = const.STATE.WALK
                    character.hp = character.hp - 15
                    const.SOUND.DAMMAGE_FIVE:play()
                    character.dammageDuration = 0.5

                end


                if character.hp <= 0 then

                    character.state = const.STATE.DEAD

                end

            end


            if character.state == const.STATE.DEAD then

                if not character.isDead then

                    character.currentAnim = const.ANIM.DEAD
                    character.isDead = true
                    character.playedDeadAnim = false
                    character.target = nil

                end

            end

            -- ce n'est pas un ETAT mais un etat intermediaire si le hero se fait tuer lors d'une attaque
            if mainCharacter.hp <= 0 and not mainCharacter.isDead then

                for c = 1, #self.listCharacters do 

                    local character = self.listCharacters[c]
            
                    if character.target ~= const.TARGET.NONE and not character.isDead then
                        character.currentAnim = const.ANIM.ATTACK_ONE

                    elseif not character.isDead then
                        
                        character.currentAnim = const.ANIM.IDLE

                    end

                    character.state = const.STATE.NONE

                    mainCharacter.currentAnim = const.ANIM.DEAD
                    mainCharacter.isDead = true
                    mainCharacter.playedDeadAnim = false

                end


            end

            -- ce n'est pas un ETAT mais un pseudo etat intermediaire si le mob se fait tuer par le hero
            if character.hp <= 0 and not character.isDead and character.type ~= const.TYPE.SOLDIER then

                character.state = const.STATE.DEAD

            end


        end

        game:animation(self.listCharacters, dt)

    end


    return stateMachine

end

function moduleStateMachine.load()
    -- game.load()
    stateMachine = moduleStateMachine.run()
end

function moduleStateMachine.update(dt)
    stateMachine:state(dt)
end

function moduleStateMachine.draw()      
end



return moduleStateMachine