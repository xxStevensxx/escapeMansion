local module_mansion_map = {}

local mansion_map_metaTable = {__index =  module_mansion_map}

local quadMngr = require("quadManager")
local const = require("const")
local grid = require("grid")


function module_mansion_map.sizeGrid(grid)

    local sizeGrid = { width = 0, height = #grid}

    for row = 1, #grid do

        for column = 1, #grid[row] do

            sizeGrid.width = #grid[row]

        end

    end

    return sizeGrid

end



function module_mansion_map.new()

    -- Crée une nouvelle instance de la map du manoir avec ses propriétés initialisées
    local mansion_map =  {

        tileSheet = nil,
        tileWidth = 0,
        tileHeight = 0,
        line = 0,
        column = 0,
        quad = {},
        map = {
            line = 0, 
            column = 0,
            x = 0,
            y = 0,
            width = 0,
            height = 0,
        },
        roomNb = 0

    }

    return setmetatable(mansion_map, mansion_map_metaTable)

end


-- Crée une nouvelle map et initialise les quads selon le type (ex: manoir) pour l'instant un type
function module_mansion_map.create(pType)

    local map = module_mansion_map.new()
     local qd = quadMngr.createQuad(pType)


    -- Configure les dimensions et les quads de la tilesheet selon le quad manager
    function map:setMap()

        self.line = qd.line
        self.column = qd.column
        self.tileWidth = qd.widthQuad
        self.tileHeight = qd.heightQuad
        self.quad = qd.map
        self.tileSheet = qd.spriteSheet

    end

    -- Dessine chaque pièce en fonction de sa grille et des tiles dans la tilesheet
    function map:draw(listRooms)

        
        local tileID

        local offsetX 
        local offsetY

        -- salle de depart toujours la premiere donc on peux mettre en dur
        -- on recupere en amont la salle de depart pour afficher le reste en fonciton de cette salle
        local startRoom = listRooms[1]
        local startRoomSize = module_mansion_map.sizeGrid(startRoom.grid)

        local startRoomWidth = startRoomSize.width * self.tileWidth * _G.scale
        local startRoomHeight = startRoomSize.height * self.tileHeight * _G.scale 

        local centerX = (_G.screenWidth / 2) - (startRoomWidth / 2)
        local centerY = (_G.screenHeight / 2) - (startRoomHeight / 2)

        for roomIndex = 1, #listRooms do

            local room = listRooms[roomIndex]

            if #room.grid then 

                local sizeMap = module_mansion_map.sizeGrid(room.grid)
                self.map.width = sizeMap.width * self.tileWidth  * _G.scale
                self.map.height = sizeMap.height * self.tileHeight * _G.scale

                --decalage par rapport à la salle de départ
                offsetX = (room.column - startRoom.column) * self.map.width
                offsetY = (room.row - startRoom.row) * self.map.height 

                for row = 1, #room.grid do

                    for column = 1, #room.grid[row] do

                        tileID = room.grid[row][column]

                        -- Dessiner la tuile correspondante avec mise à l’échelle
                        love.graphics.draw(self.tileSheet, self.quad[tileID], centerX + offsetX + (column - 1) * self.tileWidth * _G.scale, centerY + offsetY + (row - 1) * self.tileHeight * _G.scale, 0, _G.scale, _G.scale)                    
                    end

                end

            end

        end

        -- Décorations fixes dessinées à des positions données a developper
        love.graphics.draw(self.tileSheet, self.quad[47],100, 100, 0, _G.scale, _G.scale)
        love.graphics.draw(self.tileSheet, self.quad[40],250, 80, 0, _G.scale, _G.scale)
        love.graphics.draw(self.tileSheet, self.quad[78],450, 100, 0, _G.scale, _G.scale)
        love.graphics.draw(self.tileSheet, self.quad[87],550, 340, 0, _G.scale, _G.scale)


    end

    return map

end


-- Charge la map en créant la map du manoir et en configurant la grille des pièces
function module_mansion_map.load()

    map = module_mansion_map.create(const.MAP.MANSION)
    map:setMap()

end

-- Dessine la map
function module_mansion_map.draw(grid)

    map:draw(grid)

end


return module_mansion_map 