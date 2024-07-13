local Stickman = {}
Stickman.__index = Stickman

-- Constants
local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local MAN_WIDTH = 250  -- Desired width of the man images
local MAN_HEIGHT = 200  -- Desired height of the man images
local MOVE_SPEED = 1000  -- Speed in pixels per second
local ANIMATION_DELAY = 0.1  -- Time in seconds per frame

local FLOOR = SCREEN_HEIGHT - MAN_HEIGHT / 2  -- Adjusted floor position

local flux = require "flux"

-- Constructor
function Stickman.new(position)
    local self = setmetatable({}, Stickman)

    -- Load images
    self.name = "Stickman"
    local image_path = "man/"
    self.man_stand_img = love.graphics.newImage(image_path .. "man-stand.png")
    self.man_run1_img = love.graphics.newImage(image_path .. "man-run1.png")
    self.man_run2_img = love.graphics.newImage(image_path .. "man-run2.png")
    self.man_run3_img = love.graphics.newImage(image_path .. "man-run3.png")
    self.ak = false
    -- Group all images in a table for easy access
    self.man_images = { self.man_run1_img, self.man_run2_img, self.man_run3_img }

    -- Initial setup
    self.position = {
        x = position and position.x or SCREEN_WIDTH / 2,
        y = position and position.y or FLOOR
    }

    self.is_flipped = false  -- Track if image is flipped horizontally
    self.animation_counter = 0
    self.current_frame = 1  -- Start with first running frame
    self.is_moving = false  -- Track if the stickman is moving

    self.width = MAN_WIDTH
    self.height = MAN_HEIGHT

    return self
end

-- Method to draw the stickman
function Stickman:draw()
    local img = self.man_stand_img
    if self.is_moving then
        img = self.man_images[self.current_frame]
    end

    local scaleX = self.is_flipped and -1 or 1
    love.graphics.draw(img, self.position.x, self.position.y, 0, scaleX * (MAN_WIDTH / img:getWidth()), MAN_HEIGHT / img:getHeight(), img:getWidth() / 2, img:getHeight() / 2)
end

-- Method to update animation and movement
function Stickman:updateAnimation(dt)


    if self.ak == true then
        local image_path = "man/"
        self.man_stand_img = love.graphics.newImage(image_path .. "man-ak-stand.png")
        self.man_run1_img = love.graphics.newImage(image_path .. "man-ak-run.png")
        self.man_run2_img = love.graphics.newImage(image_path .. "man-ak-run2.png")
        self.man_run3_img = love.graphics.newImage(image_path .. "man-ak-run3.png")
        self.man_images = { self.man_run1_img, self.man_run2_img, self.man_run3_img }
    end


    if self.is_moving then
        if self.animation_counter >= ANIMATION_DELAY then
            self.animation_counter = 0
            self.current_frame = (self.current_frame % #self.man_images) + 1
        end

        self.animation_counter = self.animation_counter + dt

        -- Move man_img with Flux
        local move_distance = MOVE_SPEED * dt
        if self.is_flipped then
            flux.to(self.position, 0.1, { x = self.position.x - move_distance })
        else
            flux.to(self.position, 0.1, { x = self.position.x + move_distance })
        end
    end
end

-- Method to update the game state
function Stickman:update(dt)
    flux.update(dt)  -- Update Flux with delta time
    self:updateAnimation(dt)
end

local jumpHeight = 120

function Stickman:jump()
    flux.to(self.position, 0.5, { y = self.position.y - jumpHeight })
    :ease("quadout")
    :oncomplete(function()
        -- Move the object back down
        flux.to(self.position, 0.5, { y = FLOOR })
            :ease("quadin")
    end)
end

-- Collision detection method
function Stickman:checkCollision(other)
    return self.position.x < other.position.x + other.width and
           self.position.x + self.width > other.position.x and
           self.position.y < other.position.y + other.height and
           self.position.y + self.height > other.position.y
end

-- Collision handling method
function Stickman:handleCollision(other)
    if self:checkCollision(other) then
        print("Stickman collided with " .. other.name)
        -- Additional collision handling logic can go here
    end
end

-- Cleanup method (if needed)
function Stickman:destroy()
    -- Clean up images or any other resources if necessary
end

return Stickman
