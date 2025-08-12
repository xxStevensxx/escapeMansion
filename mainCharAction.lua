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

-- Fonction qui permet au personnage principal de tirer une flèche sur les cibles visibles
    function modulMainCharAction.shoot(listCharacters, mainCharacter)
        
        -- Ne pas tirer si le cooldown n’est pas terminé
        -- if mainCharacter.cooldown > 0 then return end

            -- Jouer le son de tir d’arc
            const.SOUND.BOW_SHOOT:play()


        for character = 1, #listCharacters do

            local target = listCharacters[character]
            local angle

            -- Ignorer les soldats (ou ennemis de type SOLDIER)
            if target.type ~= const.TYPE.SOLDIER then

                -- Calculer la distance entre le personnage principal et la cible
                local distance = math.dist(mainCharacter.x, mainCharacter.y, target.x, target.y)

                -- Si la cible est dans la vision du personnage principal
                if distance <= mainCharacter.vision then

                    local arrowSpeed = 1500

                     -- Estimation du temps que la flèche mettra à arriver sur sa cible
                    local arrowFlyTime = distance / arrowSpeed

                    local targetFuturPosX = target.x + target.vX * arrowFlyTime
                    local targetFuturPosY = target.y + target.vY * arrowFlyTime

                    
                    -- Calculer l’angle entre le personnage principal et la cible
                    if target.vX == 0  and target.vY == 0 then

                        angle = math.angle(mainCharacter.x, mainCharacter.y, target.x, target.y)    

                    else

                        angle = math.angle(mainCharacter.x, mainCharacter.y, targetFuturPosX, targetFuturPosY)

                    end

                    -- Créer une nouvelle flèche partant du personnage principal vers la cible
                    local arrow = {

                        x = mainCharacter.x,
                        y = mainCharacter.y,
                        angle = angle,
                        speed = arrowSpeed,
                        image = const.SPRITE.ARROW

                    }

                    -- Ajouter la flèche à la liste des flèches actives
                    table.insert(listArrows, arrow)
                    

                end

            end

        end

            -- Réinitialiser le cooldown pour empêcher un tir immédiat suivant
            mainCharacter.cooldown = 0.8
        
    end

    -- Fonction vide prévue pour l’attaque au corps à corps (slash)
    function modulMainCharAction.slash()

        --TODO

    end

    function modulMainCharAction.load()
        modulMainCharAction.new()
    end

    -- Met à jour l’état du personnage principal et des flèches
    function modulMainCharAction.update(listCharacters, mainCharacter, dt)

        if mainCharacter.cooldown > 0 then

             mainCharacter.cooldown = util.timer(mainCharacter.cooldown, dt)

        end

        -- Parcours à l’envers pour gérer suppression des flèches hors écran ou après collision
        for arrowIndex = #listArrows, 1, -1 do

            local arrow = listArrows[arrowIndex]

            -- Calcul du déplacement de la flèche selon sa vitesse et son angle
            local vX = (arrow.speed * dt) * math.cos(arrow.angle)
            local vY = (arrow.speed * dt) * math.sin(arrow.angle)

            -- Mise à jour de la position de la flèche
            arrow.x = arrow.x  + vX
            arrow.y = arrow.y  + vY

            -- Vérification de collision entre flèche et cibles
            if arrow.x < 0 or arrow.x > _G.screenWidth or arrow.y < 0 or arrow.y > _G.screenHeight then

                table.remove(listArrows, arrowIndex)

            end

            -- Ignorer les soldats et les cibles déjà mortes
            for character = 1, #listCharacters do

                local target = listCharacters[character]

                if target.type ~= const.TYPE.SOLDIER then

                    local distance = math.dist(arrow.x, arrow.y, target.x, target.y)

                    -- Si la flèche touche la cible (distance inférieure à 5)
                    if distance < 5 and not target.isDead then

                        target.state = const.STATE.DAMMAGE

                        -- Supprimer la flèche après impact
                        table.remove(listArrows, arrowIndex)

                    end

                end

            end

        end
        
        
    end

    -- Supprimer la flèche après impact
    function modulMainCharAction.draw()

        for arrow = 1, #listArrows do

            local arrow = listArrows[arrow]

            love.graphics.draw(arrow.image, arrow.x, arrow.y, arrow.angle, _G.scale, _G.scale, arrow.image:getWidth() / 2, arrow.image:getHeight() / 2)
            
        end

    end


    return modulMainCharAction



 