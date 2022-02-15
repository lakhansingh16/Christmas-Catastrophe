local Coin = {}
local Player = require("Player")
Coin.__index = Coin
local Sound = require("sound")
local ActiveCoins = {}
Sound:init("coin","sfx/coin_pickup3.wav","static")

function Coin.new(x,y)
    local instance = setmetatable({}, Coin)
    instance.x = x
    instance.y = y
    instance.img = love.graphics.newImage("png/coins/COIN.png")
    instance.width = instance.img:getWidth()
    instance.height = instance.img:getHeight()
    instance.scaleX = 1 
    instance.randomTime = math.random(0, 100)
    instance.tobeRemoved = false
    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x, instance.y,"static")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body,instance.physics.shape)
    instance.physics.fixture:setSensor(true)
    table.insert(ActiveCoins,instance)
end

function Coin:update(dt)
    self:spin(dt)
    self:checkRemove()
end

function Coin:spin(dt)
    self.scaleX = math.sin(love.timer.getTime()*3 + self.randomTime)
    
end

function Coin.updateAll(dt)
    for i,instance in ipairs(ActiveCoins) do
        instance:update(dt)
    end
end

function Coin:draw()
    love.graphics.draw(self.img,self.x,self.y,0, self.scaleX,1,self.width/2, self.height/2)
end

function Coin.drawAll()
    for i,instance in ipairs(ActiveCoins) do
        instance:draw()
    end
end

function Coin:remove()
    for i,instance in ipairs(ActiveCoins) do
        if instance == self then
            Player:incrementCoins()
            print(Player.coins)
            self.physics.body:destroy()
            table.remove(ActiveCoins,i)
        end
    end

end

function Coin:checkRemove()
    if self.tobeRemoved then
        self:remove()     
    end
end

function Coin.beginContact(a,b,collision)
    for i, instance in ipairs(ActiveCoins) do
        if a==instance.physics.fixture or b==instance.physics.fixture then
            if a== Player.physics.fixture or b==Player.physics.fixture then
                instance.tobeRemoved = true
                Sound:play("coin","coin",1, 1, false)
                return true
            end
        end
    end
end

function Coin:removeAll()
    for i,v in ipairs(ActiveCoins) do
        v.physics.body:destroy()
    end
    ActiveCoins = {}
end

return Coin