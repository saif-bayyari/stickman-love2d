local flux = require "flux"

local Entity = {}
Entity.__index = Entity

function Entity:new(name, position, imagePath, collisionFunction, collisionSoundEffectPath, animationType)
    local instance = setmetatable({}, Entity)
    instance.name = name
    instance.position = position or {x = 0, y = 0}
    instance.startPosition = {x = position.x, y = position.y}  -- Store the starting position for reference
    instance.imagePath = imagePath
    instance.image = love.graphics.newImage(imagePath)
    instance.collisionFunction = collisionFunction
    instance.collisionSoundEffect = love.audio.newSource(collisionSoundEffectPath, "static")
    instance.animationType = animationType
    instance.hoverRange = 20   -- Adjust the range in which the entity hovers
    instance.floatAmplitude = 10   -- Adjust the amplitude of the float motion
    instance.floatFrequency = 1    -- Adjust the frequency of the float motion
    instance.isFloating = false
    instance.width = instance.image:getWidth()
    instance.height = instance.image:getHeight()
    return instance
end

function Entity:update(dt)
    if self.isFloating then
        -- Calculate floating motion based on sine function
        local hoverOffset = self.hoverRange * math.sin(2 * math.pi * self.floatFrequency * love.timer.getTime())
        self.position.y = self.startPosition.y + hoverOffset
    end
end

function Entity:startFloating()
    self.isFloating = true
end

function Entity:stopFloating()
    self.isFloating = false
end

function Entity:display()
    love.graphics.draw(self.image, self.position.x, self.position.y)
end

function Entity:checkCollision(other)
    return self.position.x < other.position.x + other.width and
           self.position.x + self.width > other.position.x and
           self.position.y < other.position.y + other.height and
           self.position.y + self.height > other.position.y
end

function Entity:handleCollision(other)
    if self:checkCollision(other) then
        if self.collisionFunction then
            self.collisionFunction(self, other)
        end
        -- Play collision sound effect
      

    end
end

return Entity
