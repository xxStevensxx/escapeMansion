-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
  end
  
-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")
love.graphics.setDefaultFilter("nearest", "nearest", 1)
-- local fps = love.timer.getFPS()

local character = require("character")
local mansion = require("mansion")

local game = require("game")
local stateMachine = require("stateMachine")

function love.load()

    _G.screenWidth, _G.screenHeight = love.graphics.getDimensions()
    math.randomseed(os.time())
    math.random() ; math.random() ; math.random()

    character.load()
    mansion.load()
    stateMachine.load()
    
end

function love.update(dt)
    game.update(dt)
    stateMachine.update(dt)
end

function love.draw()
    mansion.draw()
    stateMachine.draw()
    game.draw()
end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    end

    mansion.keypressed(key)
    game.keypressed(key)
end