local Stickman = require "stickman"
local Entity = require "entity"
local Item = require "item"
local player
local player2
local entity1

-- Table to store log messages
local logMessages = {}

-- Function to log messages
local function log(message)
    table.insert(logMessages, message)
    if #logMessages > 10 then
        table.remove(logMessages, 1) -- Keep only the last 10 messages
    end
end

local function exampleCollisionFunction(entity1, entity2)
    return
end

function love.load()
    log("halo")
    love.window.setMode(1280, 720)
    love.graphics.setBackgroundColor(1, 1, 1)  -- Set background color to white (R, G, B in range 0-1)

    entity1 = Item:new("Entity1", {x = 100, y = 300}, "entities/ak47/ak47.png", exampleCollisionFunction, "entities/ak47/ak47equip.mp3", "hover")
    player = Stickman.new()
    player2 = Stickman.new()
    player2.position.x = player.position.x + 250  -- Position the second player differently to avoid overlap
    
    -- Start entity1 hovering
    entity1:startFloating()
end

function love.update(dt)
    player:update(dt)
    player2:update(dt)
    entity1:update(dt)
    
    -- Handle collision with player (example)
    entity1:handleCollision(player)
    entity1:handleCollision(player2)
end

function love.draw()
    player:draw()
    player2:draw()
    entity1:display()
    
    -- Draw log messages
    love.graphics.setColor(0, 0, 0) -- Set text color to black
    for i, message in ipairs(logMessages) do
        love.graphics.print(message, 10, 10 + (i - 1) * 15)
    end
    
    -- Reset color to white
    love.graphics.setColor(1, 1, 1)
end

function love.keypressed(key)
    if key == "a" then
        player.is_flipped = true
        player.is_moving = true
    elseif key == "d" then
        player.is_flipped = false
        player.is_moving = true
    elseif key == "space" then
        player:jump()
    end
end

function love.keyreleased(key)
    if key == "a" or key == "d" then
        player.is_moving = false
        player.animation_counter = 0
        player.current_frame = 1
    end
end
