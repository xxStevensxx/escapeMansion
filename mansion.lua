local modulMansion = {}

local mansion_metaTable = {__index = modulMansion}

local map = require("mansion_map")

local listRooms = {}

--Generation de salle et leurs etats
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


function modulMansion.new()

    local mansion = {

        width = 40,
        height = 20,
        nbRow = 3,
        nbColumn = 5,
        spaceBetween = 10,
        miniMap = {},
        map = {},
        roomStart = nil,
        
    }

        mansion.nbRooms = mansion.nbRow * mansion.nbColumn
    
    return setmetatable(mansion, mansion_metaTable)

end


function modulMansion.createMansion()

    local mansion = modulMansion.new()


    function mansion:mapGenerator()

        --remet la miniMap à zero 
        self.miniMap = {}
        -- remetons les salles à zero aussi
        listRooms = {}

        for nRow = 1, self.nbRow do

            self.miniMap[nRow] = {}

            for nColumn = 1, self.nbColumn do

                self.miniMap[nRow][nColumn] = roomGenerator(nRow, nColumn)

            end
        end
    end

    -- selectionne une salle de depart au hasard sur la minimap
    function mansion:setRoomStart()

        local randomRow = math.random(1, self.nbRow)
        local randomColumn = math.random(1, self.nbColumn)

        self.roomStart = self.miniMap[randomRow][randomColumn]
        self.roomStart.open = true

    end


    --creer un chemin de salle aleatoire dans le donjon
    function mansion:RandomizeRoomMansion(pNbRooms)

        --securité si toutes les salles sont ouverte et que plus aucune salle est placable on evite la boucle infini
        local maxAttempt = 0

        -- on commence à partir de la salle de depart
         table.insert(listRooms, self.roomStart)
        -- nb de salle souhaité à modifier selon difficulté souhaité

        while #listRooms < pNbRooms and maxAttempt < 150 do

            maxAttempt = maxAttempt + 1

            local nRoom = math.random(1, #listRooms)
            local nRow = listRooms[nRoom].row
            local nColumn = listRooms[nRoom].column
            local room = listRooms[nRoom]
            local newRoom = nil

            local direction = math.random(1, 4)

            --haut
            if direction == 1 and nRow > 1 then

                newRoom = self.miniMap[nRow -1][nColumn]
                if newRoom.open == false then
                    room.doorUp = true
                    newRoom.doorDown = true
                    newRoom.open = true
                    table.insert(listRooms,newRoom)

                end
            
            --droite
            elseif direction == 2 and nColumn < self.nbColumn then

                newRoom = self.miniMap[nRow][nColumn + 1]
                if newRoom.open == false then

                    room.doorRight = true
                    newRoom.doorLeft = true
                    newRoom.open = true
                    table.insert(listRooms,newRoom)

                end

            --bas
            elseif direction == 3 and nRow < self.nbRow then

                newRoom = self.miniMap[nRow + 1][nColumn]
                if newRoom.open == false then

                    room.doorDown = true
                    newRoom.doorUp = true
                    newRoom.open = true
                    table.insert(listRooms,newRoom)

                end

            --gauche
            elseif direction == 4 and nColumn > 1 then
            
                newRoom = self.miniMap[nRow][nColumn - 1]
                if newRoom.open == false then

                    room.doorLeft = true
                    newRoom.doorRight = true
                    newRoom.open = true
                    table.insert(listRooms,newRoom)
                end

            end

        end

    end

    function mansion:draw()

        local x = 5
        local y = 5

        for nRow = 1, self.nbRow do 
            
            --remet x a 5 vu qu'on deplace sa position en fonction du precedent rectangle
            x = 5
            
            for nColumn = 1, self.nbColumn do

                if self.miniMap[nRow][nColumn].open and self.miniMap[nRow][nColumn] == self.miniMap[self.roomStart.row][self.roomStart.column]  then

                    love.graphics.setColor(0, 1, 0)

                elseif self.miniMap[nRow][nColumn].open then

                    love.graphics.setColor(1, 1, 1)

                elseif not self.miniMap[nRow][nColumn].open then

                    love.graphics.setColor(0.3, 0.3, 0.3)

                end                               

                -- on dessine les portes
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

                love.graphics.rectangle("fill", x , y, self.width, self.height)
                -- lui met une position en fonction du precedent rectangle
                x = x + self.width + self.spaceBetween

            end
            -- lui met une position en fonction du precedent rectangle
            y = y + self.height + self.spaceBetween
            
        end
    end

    return mansion
    
end

function modulMansion.load()
    ms = modulMansion.createMansion()
    ms:mapGenerator()
    ms:setRoomStart()
    ms:RandomizeRoomMansion(10)  
    map.load(listRooms)
end


function modulMansion.draw()
    ms:draw()
    map.draw(listRooms)
end


function modulMansion.keypressed(key)

    if key == "space" then

        ms = modulMansion.createMansion()
        ms:mapGenerator()
        ms:setRoomStart()
        ms:RandomizeRoomMansion(10)
        
         
    end
end


return modulMansion