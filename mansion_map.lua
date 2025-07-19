local module_mansion_map = {}

local mansion_map_metaTable = {__index =  module_mansion_map}

local quadMngr = require("quadManager")
local const = require("const")
local grid = require("grid")


function module_mansion_map.new()

    local mansion_map =  {

        tileSheet = nil,
        tileWidth = 0,
        tileHeight = 0,
        line = 0,
        column = 0,
        quad = {},
        map = {
            grid = {},
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        },
        roomNb = 0

    }

    return setmetatable(mansion_map, mansion_map_metaTable)

end


function module_mansion_map.create(pType)

    local map = module_mansion_map.new()
    local qd = quadMngr.createQuad(pType)


    function map:setMap()
        
        self.line = qd.line
        self.column = qd.column
        self.tileWidth = qd.widthQuad
        self.tileHeight = qd.heightQuad
        self.quad = qd.map
        self.tileSheet = qd.spriteSheet

    end


    function map:getGridForRoom(listRooms)

        for room = 1, #listRooms do

            local room = listRooms[room]

            local up = room.doorUp
            local right = room.doorRight
            local down = room.doorDown
            local left = room.doorLeft

            -- Cas de figure selon les directions ouvertes
            if up and right and down and left then
                -- print("Toutes les portes sont ouvertes")
                table.insert(self.map.grid,grid.MANSION.ROOM_ONE)
            
            elseif up and right and down then
                -- print("Portes : haut, droite, bas")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)
            
            elseif up and right and left then
                -- print("Portes : haut, droite, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif up and down and left then
                -- print("Portes : haut, bas, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif right and down and left then
                -- print("Portes : droite, bas, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif up and right then
                -- print("Portes : haut, droite")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif up and down then
                -- print("Portes : haut, bas")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif up and left then
                -- print("Portes : haut, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif right and down then
                -- print("Portes : droite, bas")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif right and left then
                -- print("Portes : droite, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif down and left then
                -- print("Portes : bas, gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif up then
                -- print("Porte : haut")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif right then
                -- print("Porte : droite")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif down then
                -- print("Porte : bas")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            elseif left then
                -- print("Porte : gauche")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            else
                -- print("Aucune porte")
                table.insert(self.map.grid,grid.MANSION.ROOM_TWO)

            end

        end

    end


    function map:draw()

        local tileID

        for room = 1, #self.map.grid do

            local room = self.map.grid[room]

            for row = 1, #room do

                for column = 1, #room[row] do

                    tileID =  room[row][column]

                    love.graphics.draw(self.tileSheet, self.quad[tileID], column  * self.tileHeight * 3,  row  * self.tileWidth * 3, 0, 3, 3)

                end
            end

        end

        --deco
        love.graphics.draw(self.tileSheet, self.quad[47],100, 100, 0, 3, 3)
        love.graphics.draw(self.tileSheet, self.quad[40],250, 80, 0, 3, 3)
        love.graphics.draw(self.tileSheet, self.quad[78],450, 100, 0, 3, 3)
        love.graphics.draw(self.tileSheet, self.quad[87],550, 340, 0, 3, 3)

        local mouseX = love.mouse.getX()
        local mouseY = love.mouse.getY()

        local r = math.floor(mouseX / self.tileWidth) + 1
        local c = math.floor(mouseY / self.tileHeight) + 1

    end

    return map

end


function module_mansion_map.load(listRooms)
    map = module_mansion_map.create(const.MAP.MANSION)
    map:setMap()
    map:getGridForRoom(listRooms)
end

function module_mansion_map.draw(listRooms)
    map:draw(listRooms)
end


return module_mansion_map 