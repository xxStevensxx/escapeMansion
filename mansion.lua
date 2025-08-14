local modulMansion = {}

local mansion_metaTable = {__index = modulMansion}

local map = require("mansion_map")
local grid = require("grid")

local listRooms = {}
local ms

--var a modifié pour le nb de salle souhaité lors de la generation, max = row * column
local nb = 5

-- a modifier si on veux un manoir plus grand donc potentiellement un nb de salle max augmenté (aucun rapport avec la gestion des salles)
local row = 3
local column = 5




-- Génération d'une salle avec ses coordonnées et état initial (portes fermées)
local function roomGenerator(pRow, pColumn)

    local room = {

        row = pRow,
        column = pColumn,
        open = false,
        doorUp = false,
        doorRight = false,
        doorDown = false,
        doorLeft = false

    }

    return room

end



local function addGrid(room)

    for _, room in ipairs(listRooms) do

        local up = room.doorUp
        local down = room.doorDown
        local left = room.doorLeft
        local right = room.doorRight
        local open = room.open

        -- if not room.open then return end

        -- j'ai pas trouvé moins reberbatif...
        if up and down and left and right and open then
                 -- Toutes les portes sont ouvertes
                 room.grid = grid.MANSION.ROOM_UDRL

            elseif up and down and left and not right and open then
                -- Droite fermée, le reste ouvert         
                room.grid = grid.MANSION.ROOM_UDL
 
            elseif up and down and not left and right and open then
                -- Gauche fermée
                room.grid = grid.MANSION.ROOM_UDR
               
            elseif up and not down and left and right and open then
                -- Bas fermé
                room.grid = grid.MANSION.ROOM_URL
               
            elseif not up and down and left and right and open then
                -- Haut fermé
                room.grid = grid.MANSION.ROOM_DRL

            elseif up and down and not left and not right and open then
                -- Gauche et droite fermées
                room.grid = grid.MANSION.ROOM_UD
               
            elseif up and not down and not left and right and open then
                -- Bas et gauche fermées            
                room.grid = grid.MANSION.ROOM_UR  
               
            elseif not up and not down and left and right and open then
                -- Haut et bas fermées
                room.grid = grid.MANSION.ROOM_RL
               
            elseif not up and down and not left and right and open then
                -- Haut et gauche fermées
                room.grid = grid.MANSION.ROOM_DR
               
            elseif not up and not down and not left and right and open then
                -- Seule droite ouverte
                room.grid = grid.MANSION.ROOM_R
               
            elseif not up and down and not left and not right and open then
                -- Seule bas ouverte
                room.grid = grid.MANSION.ROOM_D
               
            elseif up and not down and not left and not right and open then
                -- Seule haut ouverte
                room.grid = grid.MANSION.ROOM_U
               
            elseif not up and not down and left and not right and open then
                -- Seule gauche ouverte
                room.grid = grid.MANSION.ROOM_L
               
            elseif up and not down and left and not right and open then
                -- Droite fermée, haut et gauche ouverts
                room.grid = grid.MANSION.ROOM_UL

            elseif not up and down and left and not right and open then
                -- Droite haut fermée, bas et gauche ouverts
                room.grid = grid.MANSION.ROOM_DL
                
            elseif not up and not down and not left and not right and open then
                -- Toutes les portes sont fermées
                room.grid = grid.MANSION.ROOM
               
            else

                room.grid = grid.MANSION.ROOM_UDRL

            end

        end

    end


-- Création d'une nouvelle instance de manoir avec paramètres de base
function modulMansion.new()

    local mansion = {

        width = 40,
        height = 20,
        nbRow = row,
        nbColumn = column,
        spaceBetween = 10,
        miniMap = {},
        grid = {},
        roomStart = nil,
        
    }

        mansion.nbRooms = mansion.nbRow * mansion.nbColumn
    
    return setmetatable(mansion, mansion_metaTable)

end


-- Création et gestion d'un manoir avec génération des pièces et de leur état
function modulMansion.createMansion()

    local mansion = modulMansion.new()


    function mansion:mapGenerator()

        -- Réinitialise la miniMap et la liste des salles
        self.miniMap = {}
        listRooms = {}


        -- Génère la grille des salles (miniMap)
        for nRow = 1, self.nbRow do

            self.miniMap[nRow] = {}

            for nColumn = 1, self.nbColumn do

                self.miniMap[nRow][nColumn] = roomGenerator(nRow, nColumn)

            end
        end
    end

    -- Sélectionne aléatoirement une salle de départ dans la miniMap et l'ouvre
    function mansion:setRoomStart()

        local randomRow = math.random(1, self.nbRow)
        local randomColumn = math.random(1, self.nbColumn)

        self.roomStart = self.miniMap[randomRow][randomColumn]
        self.roomStart.open = true

    end


    -- Crée un chemin aléatoire de salles ouvertes dans le manoir
    function mansion:RandomizeRoomMansion(pNbRooms)

        -- Evite boucle infinie en limitant les tentatives
        local maxAttempt = 0

        -- on commence à partir de la salle de depart
         table.insert(listRooms, self.roomStart)


        -- Tant qu'on a pas atteint le nombre souhaité de salles ouvertes
        while #listRooms < pNbRooms and maxAttempt < 150 do

            maxAttempt = maxAttempt + 1

            local nRoom = math.random(1, #listRooms)
            local nRow = listRooms[nRoom].row
            local nColumn = listRooms[nRoom].column
            local room = listRooms[nRoom]
            local newRoom = nil

            local direction = math.random(1, 4)

            -- Selon la direction, tente d'ouvrir une nouvelle salle adjacente
            --haut
            if direction == 1 and nRow > 1 then

                newRoom = self.miniMap[nRow -1][nColumn]
                if newRoom.open == false then
                    room.doorUp = true
                    -- room.grid = grid.MANSION.ROOM_UD
                    newRoom.doorDown = true
                    newRoom.open = true
                    -- newRoom.grid = grid.MANSION.ROOM_D
                    --TODO
                     table.insert(listRooms,newRoom)


                end
            
            --droite
            elseif direction == 2 and nColumn < self.nbColumn then

                newRoom = self.miniMap[nRow][nColumn + 1]
                if newRoom.open == false then

                    room.doorRight = true
                    -- room.grid = grid.MANSION.ROOM_R
                    newRoom.doorLeft = true
                    newRoom.open = true
                    -- newRoom.grid = grid.MANSION.ROOM_UDRL
                    table.insert(listRooms,newRoom)

                end

            --bas
            elseif direction == 3 and nRow < self.nbRow then

                newRoom = self.miniMap[nRow + 1][nColumn]
                if newRoom.open == false then

                    room.doorDown = true
                    -- room.grid = grid.MANSION.ROOM_R
                    newRoom.doorUp = true
                    newRoom.open = true
                    -- newRoom.grid = grid.MANSION.ROOM_U
                    table.insert(listRooms,newRoom)

                end

            --gauche
            elseif direction == 4 and nColumn > 1 then
            
                newRoom = self.miniMap[nRow][nColumn - 1]
                if newRoom.open == false then

                    room.doorLeft = true
                    -- room.grid = grid.MANSION.ROOM_L
                    newRoom.doorRight = true
                    newRoom.open = true
                    -- newRoom.grid = grid.MANSION.ROOM_R
                    table.insert(listRooms,newRoom)
                end

            end

            --on ajoute nos grid en fonction des portes ouvertes pour des salles differents
            addGrid(listRooms)
            
        end
    end

    -- Dessine la miniMap avec les salles et leurs portes
    function mansion:draw()

        local x = 300
        local y = 300

        for nRow = 1, self.nbRow do 
            
            x = 5 -- Reset position x à chaque nouvelle ligne
            local count = 0
            
            for nColumn = 1, self.nbColumn do
                
                if self.miniMap[nRow][nColumn].open and self.miniMap[nRow][nColumn] == self.miniMap[self.roomStart.row][self.roomStart.column]  then

                    love.graphics.setColor(0, 1, 0)  -- salle de départ en vert

                elseif self.miniMap[nRow][nColumn].open then

                    love.graphics.setColor(1, 1, 1) -- salle ouverte en blanc

                elseif not self.miniMap[nRow][nColumn].open then

                     love.graphics.setColor(0.1, 0.1, 0.1) -- salle fermée en gris foncé

                end                               

                -- Dessine les portes présentes sur la salle
                if self.miniMap[nRow][nColumn].doorUp then
                    love.graphics.rectangle("fill", x + (self.width / 2) - 5 , y - (self.height / 2) + 5, 10, 10)
                end
                if self.miniMap[nRow][nColumn].doorRight then
                    love.graphics.rectangle("fill", x + self.width , y + (self.height / 2) - 5 , 10, 10)
                end
                if self.miniMap[nRow][nColumn].doorDown then
                    love.graphics.rectangle("fill", x + (self.width / 2) - 5 , y  + (self.height / 2) + 5 , 10, 10)
                end
                if self.miniMap[nRow][nColumn].doorLeft then
                    love.graphics.rectangle("fill", x - 5 , y + (self.height / 2) -  5 , 10, 10)
                end

                -- Dessine la salle elle-même
                love.graphics.rectangle("line", x , y, self.width, self.height)

                ------------------------------------------------------------------------------------------------

                ------------------------------------------------------------------------------------------------

                love.graphics.setColor(1, 1, 1)

                -- Décale la position x pour la prochaine salle sur la même ligne
                x = x + self.width + self.spaceBetween

            end

            -- Décale la position y pour la prochaine ligne de salles
            y = y + self.height + self.spaceBetween
            
        end
    end
    love.graphics.setColor(1, 1, 1)

    return mansion
    
end


function modulMansion.getListRooms()

    return listRooms

end

-- Initialise et génère le manoir complet au lancement
function modulMansion.load()
    ms = modulMansion.createMansion()
    ms:mapGenerator() 
    ms:setRoomStart() 
    ms:RandomizeRoomMansion(nb)  
    map.load()
end


-- Dessine la miniMap et la map principale
function modulMansion.draw()
    map.draw(listRooms) 
    ms:draw()
end


-- Recharge un nouveau manoir si la touche espace est pressée à décaler dans le gui restart
function modulMansion.keypressed(key)

    if key == "space" then

        ms = {}
        ms = modulMansion.createMansion()
        ms:mapGenerator()
        ms:setRoomStart()
        -- la logique empeche de tester avec une salle minimum 2 a cause du grid qui est initialisé apres pour la salle de depart
        ms:RandomizeRoomMansion(nb)
        
         
    end
end


return modulMansion