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
local gameState = require("gameState")
local stateMachine = require("stateMachine")
local util = require("utils")
local gui = require("gui")
local const = require("const")

function love.load()

    _G.screenWidth, _G.screenHeight = love.graphics.getDimensions()
    math.randomseed(os.time())
    math.random() ; math.random() ; math.random()
    character.load() 
    mansion.load()
    stateMachine.load()
    game.load()
    gameState.load()
    _G.scale = util.scale(3)
end

function love.update(dt)
    if gs.currentState == const.GAME_STATE.STARTED then gs:started()  return end
    game.update(dt)
    stateMachine.update(dt)
end

function love.draw()
    if gs.currentState == const.GAME_STATE.STARTED then gs:started() gameState.draw() return end -- variable globale pour gameState instance
    love.graphics.push()
    -- game.camera()
    mansion.draw()
    game.draw()
    love.graphics.pop()
end

function love.keypressed(key)

    if key == "escape" then
        love.event.quit()
    end

    mansion.keypressed(key)
    game.keypressed(key)
end