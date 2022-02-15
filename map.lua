local STI = require('sti')                    -- https://github.com/karai17
local Map ={}
local Coin = require("coin")
local Spike = require("spike")
local Cube = require("cube")
local Player = require("Player")

function Map:load()
    self.currentLevel = 1
    World = love.physics.newWorld(0,1500)
    World:setCallbacks(beginContact, endContact)
    self:init()
end

function Map:init()
    if self.currentLevel < 3 then
        self.level = STI("map/lua/"..self.currentLevel..".lua",{"box2d"})
        self.level:box2d_init(World)
        self.level.layers.solid.visible = false
        self.level.layers.entity.visible = false
        MapWidth = 80 * 16
        self:spawnEntities()
    else
        self:clear()
        Player.x = 800
        Player.y = 1400
        Player:success()
    end
end

function Map:next()
    self:clear()
    self.currentLevel = self.currentLevel + 1
    self:init()
    Player:resetPosition()
end

function Map:clear()
    self.level:box2d_removeLayer("solid")
    Coin.removeAll()
    Cube.removeAll()
    Spike.removeAll()
end

function Map:update(dt)
    if Player.x > MapWidth - 16 then
        self:next()
    end
    
end

function Map:spawnEntities()
    for i,v in ipairs(self.level.layers.entity.objects) do
        if v.type == "spike" then
            Spike.new(v.x + v.width/2,v.y + v.height/2)
        elseif v.type == "c" then
            Cube.new(v.x + v.width/2,v.y + v.height/2)
        elseif v.type == "coin" then
            Coin.new(v.x ,v.y)
        end
    end
end

return Map