local moduleGui = {}

local gui_metaTable = {__index, moduleGui}


function moduleGui.new()

    local gui = {}

    return setmetatable(gui, gui_metaTable)
end


return gui