local util = {}
local const = require("const")
-- Returns the distance between two points.
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end
-- Returns the angle between two vectors assuming the same origin.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function util.timer(sec, dt)

    -- if sec <= 0 then sec = 3 end

    if sec > 0 then

        sec = sec - dt
        
    end

    return sec

end


function util.sndClone()

    for snd = 1, #const.SOUND do

        const.SOUND[snd]:clone()

    end
end


function util.scale(scale)

    return scale

end


return util



