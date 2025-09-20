local moduleCamera = {}

local camera_metaTable = {__index = moduleCamera}

function moduleCamera.new()

    local camera = {}

    return setmetatable(camera, camera_metaTable)

end



function moduleCamera.cam(characterX, characterY)

    local camera = moduleCamera.new()

    camera.x = characterX 
    camera.y = characterY
    camera.worldWidth = 2500
    camera.worldHeight = 2500

    love.graphics.translate(camera.x, camera.y)

end


function moduleCamera.getCam()

    --TODO 
    
end

function moduleCamera.load()
end

function moduleCamera.draw()
end


return moduleCamera