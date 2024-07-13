local flux = require "flux"
local Entity = require "entity"

-- Items table to track all items
local items = {}

-- Item class definition
local Item = {}
Item.__index = Item

-- Constructor for Item class
function Item:new(name, position, imagePath, collisionFunction, collisionSoundEffect, animationType)
    local instance = Entity:new(name, position, imagePath, collisionFunction, collisionSoundEffect, animationType)
    setmetatable(instance, Item)
    instance.isStuck = false  -- Flag to indicate if item is stuck to the player
    instance.player = nil     -- Reference to the player object
    instance.remove = false   -- Flag to mark the item for removal

    -- Debugging: Print a message if the image failed to load
    if not instance.image then
        print("Failed to load image at path: " .. tostring(imagePath))
    end

    -- Add the instance to the items table
    table.insert(items, instance)

    return instance
end

-- Override the handleCollision method to handle item attachment to player
function Item:handleCollision(other)
    if not self.isStuck and self:checkCollision(other) and other.name == "Stickman" then
        self.isStuck = true
        self.player = other
        self:stopFloating()  -- Stop floating when item sticks to player
        print(self.name .. " is now stuck to the player!")
        self.player.ak = true
        -- Play the collision sound effect if available
        if self.collisionSoundEffect then
            love.audio.play(self.collisionSoundEffect)
        end

        self.remove = true  -- Mark item for removal
    else
        -- Use the collision function passed during the creation
        if self.collisionFunction then
            self.collisionFunction(self, other)
        end
    end
end

-- Method to determine if the item should be removed
function Item:isToBeRemoved()
    return self.remove
end

-- Update method to make item stick to player if it is stuck
function Item:update(dt)
    Entity.update(self, dt)  -- Call the base class update method
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

-- Cleanup method to handle any necessary cleanup for an item
function Item:cleanup()
    -- Perform any necessary cleanup here
    -- For example, you could nil out references if needed
    self.image = nil
    self.collisionSoundEffect = nil
end

return Item
