 local GUI = {}
 local Player = require("Player")
 local Map = require("map")

function GUI:load()
    self.coins ={}
    self.coins.img = love.graphics.newImage("png/coins/Coin1.png")
    self.coins.width = self.coins.img:getWidth()
    self.coins.height = self.coins.img:getHeight()
    self.coins.scale = 1.15
    self.coins.x = 1200
    self.coins.y = 10
    self.hearts = {}
    self.hearts.img = love.graphics.newImage("png/heart.png")
    self.hearts.width = self.hearts.img:getWidth()
    self.hearts.height = self.hearts.img:getHeight()
    self.hearts.x = 0
    self.hearts.y = 40
    self.hearts.scale = 1
    self.hearts.spacing = self.hearts.width * self.hearts.scale
end

function GUI:update(dt)
end

function GUI:displayHearts()
    for i =1,Player.health.current do
        local x = self.hearts.x + self.hearts.spacing*i
        love.graphics.draw(self.hearts.img,x, self.hearts.y, 0,self.hearts.scale,self.hearts.scale)
    end
end


function GUI:draw()
    self:displayCoins()
    self:displayHearts()
    self:displayGameOver()
end

function GUI:displayCoins()
    love.graphics.draw(self.coins.img,self.coins.x-10, self.coins.y,0,self.coins.scale,self.coins.scale)
    love.graphics.print(":"..Player.coins,self.coins.x + self.coins.width-5,self.coins.y - 5)
end

function GUI:displayGameOver()
    if Map.currentLevel > 2 then
        love.graphics.print("Game End",(love.graphics.getWidth()/ 2) -50, love.graphics.getHeight()/10)  
    end
end

return GUI