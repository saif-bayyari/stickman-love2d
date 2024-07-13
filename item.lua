local flux = require "flux"
local Entity = require "entity"

-- Item class definition
local Item = {}
Item.__index = Item

-- Constructor for Item class
function Item:new(name, position, imagePath, collisionFunction, collisionSoundEffect, animationType)
    local instance = Entity:new(name, position, imagePath, collisionFunction, collisionSoundEffect, animationType)
    setmetatable(instance, Item)
    instance.isStuck = false  -- Flag to indicate if item is stuck to the player
    instance.player = nil     -- Reference to the player object

    -- Debugging: Print a message if the image failed to load
    if not instance.image then
        print("Failed to load image at path: " .. tostring(imagePath))
    end

    return instance
end

-- Override the handleCollision method to handle item attachment to player
function Item:handleCollision(other)
    if not self.isStuck and self:checkCollision(other) and other.name == "Stickman" then
        self.isStuck = true
        self.player = other
        self:stopFloating()  -- Stop floating when item sticks to player
        print(self.name .. " is now stuck to the player!")
        love.audio.play(self.collisionSoundEffect)
    else
        -- Use the collision function passed during the creation
        if self.collisionFunction then
            self.collisionFunction(self, other)
            
        end

        
    end
end

-- Update method to make item stick to player if it is stuck
function Item:update(dt)
    Entity.update(self, dt)  -- Call the base class update method

    if self.isStuck and self.player then
        -- Make the item follow the player's position
        self.position.x = self.player.position.x
        self.position.y = self.player.position.y - 25
    end
end

-- Inherit display method from Entity class
function Item:display()
    Entity.display(self)
end

-- Inherit startFloating method from Entity class
function Item:startFloating()
    Entity.startFloating(self)
end

-- Inherit stopFloating method from Entity class
function Item:stopFloating()
    Entity.stopFloating(self)
end

-- Inherit checkCollision method from Entity class
function Item:checkCollision(other)
    return Entity.checkCollision(self, other)
end

return Item
