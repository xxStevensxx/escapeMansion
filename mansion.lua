local modulMansion = {}

local mansion_metaTable = {__index = modulMansion}

local map = require("mansion_map")
local grid = require("grid")

local listRooms = {}
local ms

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


-- Création d'une nouvelle instance de manoir avec paramètres de base
function modulMansion.new()

    local mansion = {

        width = 40,
        height = 20,
        nbRow = 3,
        nbColumn = 5,
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
                    room.grid = grid.MANSION.ROOM_ONE
                    newRoom.doorDown = true
                    newRoom.open = true
                    newRoom.grid = grid.MANSION.ROOM_ONE
                     table.insert(listRooms,newRoom)


                end
            
            --droite
            elseif direction == 2 and nColumn < self.nbColumn then

                newRoom = self.miniMap[nRow][nColumn + 1]
                if newRoom.open == false then

                    room.doorRight = true
                    room.grid = grid.MANSION.ROOM_ONE
                    newRoom.doorLeft = true
                    newRoom.open = true
                    newRoom.grid = grid.MANSION.ROOM_ONE
                    table.insert(listRooms,newRoom)

                end

            --bas
            elseif direction == 3 and nRow < self.nbRow then

                newRoom = self.miniMap[nRow + 1][nColumn]
                if newRoom.open == false then

                    room.doorDown = true
                    room.grid = grid.MANSION.ROOM_ONE
                    newRoom.doorUp = true
                    newRoom.open = true
                    newRoom.grid = grid.MANSION.ROOM_ONE
                    table.insert(listRooms,newRoom)

                end

            --gauche
            elseif direction == 4 and nColumn > 1 then
            
                newRoom = self.miniMap[nRow][nColumn - 1]
                if newRoom.open == false then

                    room.doorLeft = true
                    room.grid = grid.MANSION.ROOM_ONE
                    newRoom.doorRight = true
                    newRoom.open = true
                    newRoom.grid = grid.MANSION.ROOM_ONE
                    table.insert(listRooms,newRoom)
                end

            end

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
                love.graphics.rectangle("fill", x , y, self.width, self.height)

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

-- Initialise et génère le manoir complet au lancement
function modulMansion.load()
    ms = modulMansion.createMansion()
    ms:mapGenerator() 
    ms:setRoomStart() 
    ms:RandomizeRoomMansion(5)  
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
        ms:RandomizeRoomMansion(5)
        
         
    end
end


return modulMansion