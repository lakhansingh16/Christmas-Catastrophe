love.graphics.setDefaultFilter('nearest','nearest')
local Player = require("Player")
local Coin = require("coin")
local GUI = require("gui")
local Spike = require("spike")
local Camera = require("camera")
local Cube = require("cube")
local Map = require("map")
local Sound = require("sound")

function love.load()                          --loads the game
    Sound:init("background","sfx/background1.wav", "static")
    Sound:play("background","back",1,1,true)
    Map:load()
    BackgroundImg = love.graphics.newImage('png/BG/BG.png')
    Scorefont = love.graphics.newFont('font2.TTF',42)
    Player:load()
    GUI:load()
end
    


function love.update(dt)                      --updates game every second
    World:update(dt)
    Player:update(dt)
    Sound:update()
    Coin.updateAll(dt)
    Cube.updateAll(dt)
    GUI:update(dt)
    Spike.updateAll(dt)
    Camera:setPosition(Player.x,0)
    Map:update(dt)
    
end


function love.draw()                          --draws resources and characters
    love.graphics.draw(BackgroundImg)     
    Map.level:draw(-Camera.x,-Camera.y,Camera.scale,Camera.scale)
    love.graphics.setFont(Scorefont)
    love.graphics.print('Project50',0,0)
    Camera:apply()
    Player:draw()
    Coin.drawAll()
    Spike.drawAll()
    Cube.drawAll()
    Camera:clear()
    GUI:draw()
    
end

function beginContact (a,b,collision)
    if Coin.beginContact(a,b,collision) then return end
    if Spike.beginContact(a,b,collision) then return end
    Player:beginContact(a,b,collision)

end

function love.keypressed(key)
    Player:jump(key)
    if key == "b" then
        Sound:play("test","sfx")
    end
end

function endContact (a,b,collision)
    Player:endContact(a,b,collision)
end



