local moduleStateMachine = {}

local moduleStateMachine_metaTable = {__index = moduleStateMachine}

local const = require("const")
local char = require("character")
local g = require("game")
local game = g.play()
local util = require("utils")

local stateMachine

-- Création d'une nouvelle instance de la machine à états
function moduleStateMachine.new()

    local stateMachine = {
        listCharacters = char.list()  -- Récupère la liste des personnages
    }

    return setmetatable(stateMachine, moduleStateMachine_metaTable)
end


-- Fonction principale qui lance la gestion des états
function moduleStateMachine.run()
    
    local stateMachine = moduleStateMachine.new()

    -- Méthode qui gère les états de chaque personnage à chaque frame
    function stateMachine:state(dt)

        local anim = nil
        local mainCharacter = nil

        -- Recherche du personnage principal (type SOLDIER)
        for __, character in ipairs(self.listCharacters) do 
            if character.type == const.TYPE.SOLDIER then mainCharacter = character end
        end
        
        for c = 1, #self.listCharacters do
            
            local character = self.listCharacters[c]
            local colision = game.collider(character)

            -- Calcul de la distance entre le personnage courant et le personnage principal
            local distance = math.dist(character.x, character.y, mainCharacter.x, mainCharacter.y)

            --ETAT !!  Si le personnage n'a aucun état et n'est pas le joueur
            if character.state == const.STATE.NONE and character.type ~= const.TYPE.SOLDIER then
                

                -- Si le joueur n'est pas mort
                if mainCharacter.isDead == false then

                    -- Le personnage prend une direction aléatoire et commence à marcher
                    character.angle = math.angle(character.x, character.y, math.random(_G.screenWidth), math.random(_G.screenHeight))
                    character.state = const.STATE.WALK

                else

                    -- Sinon, il reste immobile
                    character.x = character.x
                    character.y = character.y
                    character.vX = 0
                    character.vY = 0

                end


            end

            -- ETAT !!  marche (pour les ennemis)
            if character.state == const.STATE.WALK and character.type ~= const.TYPE.SOLDIER then

                character.currentAnim = const.ANIM.WALK -- applique une  animation de marche

                -- Calcul du déplacement selon l'angle et la vitesse
                character.vX = character.speed * math.cos(character.angle)
                character.vY = character.speed * math.sin(character.angle)

                character.x = character.x + character.vX * dt
                character.y = character.y + character.vY * dt

                -- Si collision, changer de direction
                if colision then character.state = const.STATE.CHANGEDIR end

                -- Si le joueur est dans le champ de vision, passer à l'état poursuite
                if distance < character.vision then

                    character.state = const.STATE.PURSUIT

                end

            end

            -- Changement de direction après collision
            if character.state == const.STATE.CHANGEDIR and character.type ~= const.TYPE.SOLDIER then

                character.currentAnim = const.ANIM.WALK

                -- Nouvelle direction aléatoire
                character.angle = math.angle(character.x, character.y, math.random(_G.screenWidth), math.random(_G.screenHeight))
                character.state = const.STATE.WALK

            end

            --ETAT !! Poursuite du joueur pour l'attaquer
            if character.state == const.STATE.PURSUIT and character.type ~= const.TYPE.SOLDIER then

                character.target = mainCharacter
                character.currentAnim = const.ANIM.WALK                
                
                -- Calcul de l'angle vers le joueur
                character.angle = math.angle(character.x, character.y, character.target.x, character.target.y)
                character.vX = character.speed * math.cos(character.angle)
                character.vY = character.speed * math.sin(character.angle)

                -- Mise à jour position
                character.x = character.x + character.vX * dt
                character.y = character.y + character.vY * dt

                -- Si le joueur sort du champ de vision, passer en état recherche
                if distance > character.vision then

                character.state = const.STATE.SEARCH
                character.target = const.TARGET.NONE

                end

                -- Si assez proche, passer en état attaquer
                if distance < character.range then

                    character.state = const.STATE.ATTACK

                end

            end

            -- ETAT!!   le mob à perdu de vue le joueur le cherche
            if character.state == const.STATE.SEARCH then
                
                -- Initialisation de la durée de recherche si non définie
                if character.watchDuration == nil then
                    
                    character.watchDuration = math.random(2, 4)

                end

                character.currentAnim = const.ANIM.IDLE

                character.x = character.x
                character.y = character.y
                currentVision = character.vision

                -- Timer de recherche
                character.watchDuration = util.timer(character.watchDuration , dt)

                -- Après la durée de recherche, retourne en marche
                if character.watchDuration <= 0 then

                    character.state = const.STATE.WALK
                    character.watchDuration = nil

                end

                -- Si le joueur revient dans le champ de vision, poursuivre à nouveau
                if distance <= character.vision then

                    character.state = const.STATE.PURSUIT

                end

            end

            local initaleCooldown = character.cooldown


            --ETAT !!  attaque sur le joueur 
            if character.state == const.STATE.ATTACK and character.target then

                -- Gestion du cooldown d'attaque
                character.cooldown = util.timer(character.cooldown, dt)

                -- Attaque rapprochée (distance < moitié de la portée)
                if distance < character.range / 2 then

                    if character.cooldown <= 0 then

                        character.currentAnim = const.ANIM.ATTACK_TWO
                        mainCharacter.currentAnim = const.ANIM.DAMMAGE                        
                        mainCharacter.hp = mainCharacter.hp - 14
                        const.SOUND.DAMMAGE_FOUR:play()

                        character.cooldown = 1

                    end

                -- Attaque à distance moyenne (distance inférieure à portée)
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

                    -- Si trop loin, revenir en poursuite
                    character.state = const.STATE.PURSUIT

                end

                -- Si joueur sort du champ de vision, passer en recherche
                if distance > character.vision then

                    character.state = const.STATE.SEARCH

                end
             
            end


            --ETAT!! personnage subit des dégâts
            if character.state == const.STATE.DAMMAGE then

                character.currentAnim = const.ANIM.DAMMAGE
                character.dammageDuration = util.timer(character.dammageDuration, dt)
                
                if character.dammageDuration <= 0 then
                    
                    character.state = const.STATE.WALK -- retour à la marche après dommage
                    character.hp = character.hp - 15
                    const.SOUND.DAMMAGE_FIVE:play()
                    character.dammageDuration = 0.5 -- reset timer dommage

                end

                -- Si PV à zéro ou moins, passe à l'état mort
                if character.hp <= 0 then

                    character.state = const.STATE.DEAD

                end

            end

            -- ETAT!! personnage mort
            if character.state == const.STATE.DEAD then

                -- Gestion mort une fois 
                if not character.isDead then

                    character.currentAnim = const.ANIM.DEAD
                    character.isDead = true
                    character.playedDeadAnim = false
                    character.target = nil

                end

            end

            -- Gestion spéciale : si le joueur meurt
            if mainCharacter.hp <= 0 and not mainCharacter.isDead then

                for c = 1, #self.listCharacters do 

                    local character = self.listCharacters[c]
            
                    if character.target ~= const.TARGET.NONE and not character.isDead then
                        character.currentAnim = const.ANIM.ATTACK_ONE -- ennemis en animation attaque pour effet sadique

                    elseif not character.isDead then
                        
                        character.currentAnim = const.ANIM.IDLE

                    end

                    character.state = const.STATE.NONE

                    -- Joueur en animation mort
                    mainCharacter.currentAnim = const.ANIM.DEAD
                    mainCharacter.isDead = true
                    mainCharacter.playedDeadAnim = false

                end


            end

            -- Si un ennemi meurt par le joueur
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


return moduleStateMachine