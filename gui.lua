local moduleGui = {}

local gui_metaTable = {__index = moduleGui}

local const = require("const")

local groups = {}


-- Création d'un groupe (contient des éléments)
function moduleGui.new()

    local group = {
        elements = {}
    }

    return setmetatable(group, gui_metaTable)

end

-- Création d'un groupe avec méthodes pour gérer les éléments
function moduleGui.newGroup()

    local group = moduleGui.new()

    function group:addElement(pElement)

        table.insert(self.elements, pElement)

    end

    function group:setVisible(pVisible)

        for _, element in pairs(self.elements) do

            element:setVisible(pVisible)

        end
        
    end


    function group:update(dt)

        for _, element in pairs(self.elements) do

            element:update(dt)

        end

    end


    function group:draw()

        love.graphics.push() -- Sauvegarde l'état graphique

        for _, element in pairs(self.elements) do

            element:draw()

        end

        love.graphics.pop() -- Restaure l'état graphique

    end

    return group

end


-- Création d'un élément de base avec position
function moduleGui.newElement(pX, pY)

    local element = {
        x = pX,
        y = pY,
    }

    function element:setVisible(pVisible)

        self.visible = pVisible

    end

    function element:update(dt)
        --TODO
    end

    return element


end

-- Création d'un panneau (rectangle ou image) avec gestion des événements
function moduleGui.newPanel(pX, pY, pWidth, pHeight, pColor)

    local panel = moduleGui.newElement(pX, pY)
    panel.width = pWidth
    panel.height = pHeight
    panel.color = pColor
    panel.image = nil
    panel.isHover = false
    panel.listEvents = {}



    function panel:setImage(pImage)

        self.image = pImage
        self.width = pImage:getWidth()
        self.height = pImage:getHeight()
        
    end


    function panel:setEvent(pEvent)

        --TODO

    end


    -- Vérifie si la souris est sur le panneau (hover) pas appliquer encore
    function panel:updatePanel(dt)

        local mouseX, mouseY = love.mouse.getPosition()


        if mouseX > self.x and mouseX < self.x + self.width and
            mouseY > self.y and mouseY < self.y + self.height then    

            if not self.isHover then
                self.isHover = true
            end

        else

            if self.isHover then

                self.isHover = false

            end

        end
    
    end


    function panel:update(dt)

        self:updatePanel(dt)

    end


    function panel:drawPanel()

        love.graphics.setColor(1, 1, 1)

        if self.image == nil then

            love.graphics.rectangle("line", self.x, self.y, self.width, self.height)

        else

            love.graphics.draw(self.image, self.x, self.y)

        end

    end


    function panel:draw()

        if not self.visible then return end
        
        self:drawPanel()

    end

    return panel

end

-- Création d'un élément texte, étend un panel
function moduleGui.newText(pX, pY, pWidth, pHeight, pHalign, pValign, pFont, pText, pColor)

    local text = moduleGui.newPanel(pX, pY, pWidth, pHeight, pColor)
    text.textWidth = pFont:getWidth(pText)
    text.textHeight = pFont:getHeight(pText)
    text.width = pWidth
    text.height = pHeight
    text.horizontaAlign = pHalign
    text.verticalHalign = pValign
    text.font = pFont
    text.text = pText


    function text:drawText()

        love.graphics.setFont(pFont)

        local x = self.x
        local y = self.y


        if self.horizontaAlign == const.TEXT.ALIGN.CENTER then

            x = x + ((self.width - self.textWidth) / 2)

        end

        if self.verticalHalign == const.TEXT.ALIGN.CENTER then

            y = y + ((self.height - self.textHeight) / 2)
            
        end


        love.graphics.print(self.text, x, y)

    end



    function text:draw()

        if not self.visible then return end

        self:drawText()

    end


    return text

end

-- Ajoute plusieurs options textuelles à un groupe dans un panel
function moduleGui.drawOptions(pOptions, pGroup, pPanel)

    local options = pOptions
    local group = pGroup
    local panel = pPanel

    local spaceBetween = 30
    local startY = panel.y 


        for i, label in pairs(options) do

        local optionText = moduleGui.newText(panel.x, (panel.y - 100) + (i - 1) * spaceBetween, panel.width, panel.height, const.TEXT.ALIGN.CENTER, const.TEXT.ALIGN.CENTER, const.FONT.KEN, label)
        
        group:addElement(optionText)
        
    end

end


-- Getters pour accéder aux groupes
function moduleGui.getGroup(groupName)

    return groups[groupName]

end


-- fonction pour cacher les groupes
function moduleGui.hideGroupe()

    for _, group in pairs(groups) do

        group:setVisible(false)

    end


end


-- Chargement initial des groupes et éléments
function moduleGui.load()

    groups.startedGroup = moduleGui.newGroup()
    groups.pauseGroup = moduleGui.newGroup()
    groups.restartGroup = moduleGui.newGroup()
    groups.quitGroup = moduleGui.newGroup()
    groups.gameoverGroup = moduleGui.newGroup()
    groups.playGroup = moduleGui.newGroup()

    local startedPanel = moduleGui.newPanel((_G.screenWidth / 2) - 200, (_G.screenHeight / 2) - 150, 400, 300)
    local pausePanel = moduleGui.newPanel(0, 0, 400, 300)
    local restartPanel = moduleGui.newPanel(0, 0, 400, 300)
    local quitPanel = moduleGui.newPanel(0, 0, 400, 300)
    local gameoverPanel = moduleGui.newPanel(0, 0, 400, 300)
    local playPanel = moduleGui.newPanel(0, 0, 600, 600)

        -- Ajout des panneaux aux groupes
    groups.startedGroup:addElement(startedPanel)
    groups.playGroup:addElement(playPanel)
    groups.pauseGroup:addElement(pausePanel)
    groups.restartGroup:addElement(restartPanel)
    groups.quitGroup:addElement(quitPanel)
    groups.gameoverGroup:addElement(gameoverPanel)


    playPanel:setImage(const.SPRITE.PANEL_ONE)
    moduleGui.drawOptions(const.TEXT.TUTO, groups.startedGroup, startedPanel)
    
    
end

function moduleGui.update(dt)

    for _, group in pairs(groups) do

        group:update(dt)

    end

end


function moduleGui.draw()

    for _, group in pairs(groups) do

        group:draw()

    end

end

return moduleGui
