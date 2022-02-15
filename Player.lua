local Player = {}
local Sound = require("sound")

function Player:load()
    self.x = 20
    self.y = 250
    self.startX = self.x
    self.startY= self.y
    self.width = 20
    self.height = 35
    self.dx = 0
    self.dy = 0
    self.maxspeed = 200
    self.accleration = 4000
    self.friction = 3500
    self.gravity = 1500
    self.grounded = false
    self.jumpHeight = -450
    self.direction = "right"
    self.State = "idle"
    self.coins = 0
    self.health ={current = 3, max = 3}
    self.alive = true

    Sound:init("jump","sfx/jump1.wav","static")
    Sound:init("spike","sfx/spike1.wav","static")
    Sound:init("success","sfx/success.wav","static")
    self:loadAssets()
    self.color = {red = 1, green = 1 ,blue = 1, speed = 3}

    self.physics = {}
    self.physics.body = love.physics.newBody(World,self.x, self.y, "dynamic")
    self.physics.body:setFixedRotation(true)
    self.physics.shape = love.physics.newRectangleShape(self.width,self.height)
    self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
    self.physics.body:setGravityScale(0)
end

function Player: loadAssets()
    self.animation = {timer=0, rate = 0.03}
    

    self.animation.run = {total=11, current =1, img={}}
    for i=1,self.animation.run.total do
        self.animation.run.img[i] = love.graphics.newImage("png/run/Run("..i..").png")
    end

    self.animation.jump ={total=16, current =1, img={}}
    for i=1,self.animation.jump.total do
        self.animation.jump.img[i] = love.graphics.newImage("png/jump/Jump ("..i..").png")
    end

    self.animation.idle = {total=16, current =1, img={}}
    for i=1,self.animation.idle.total do
        self.animation.idle.img[i] = love.graphics.newImage("png/idle/idle"..i..".png")
    end

    self.animation.draw = self.animation.idle.img[1]
    self.animation.width = self.animation.draw:getWidth()
    self.animation.height = self.animation.draw:getHeight()
end


function Player:update(dt)
    self:unTint(dt)
    self:setState()
    self:setDirection()
    self:syncPhysics()
    self:move(dt)
    self:applyGravity(dt)
    self:animate(dt)
    self:respawn()
    self:unTint(dt)
    self:limitWorld()
end

function Player:limitWorld()
    if self.x < 0 then
        self:resetPosition()
    end
end

function Player:takeDamage(amount)
    self:tintRed()
    if self.health.current - amount > 0 then
        self.health.current = self.health.current - amount
        Sound:play("spike","spike",1,1,false)
    else
        self.health.current = 0
        self:die()
        Sound:play("spike","spike",1,1,false)

    end
    print("Player health:".. self.health.current)
end

function Player:die()
    print("player died")
    self.alive = false
end

function Player:respawn()
    if not self.alive then
        self:resetPosition()
        self.health.current = self.health.max
        self.alive =true
    end
end

function Player:resetPosition()
    self.physics.body:setPosition(self.startX,self.startY)
end


function Player:incrementCoins()
    self.coins = self.coins +1
end

function Player:setState()
    if not self.grounded then
        self.State = "jump"
    elseif self.dx == 0 then
        self.State = "idle"
    else
        self.State = "run"
    end
end

function Player:setDirection()
    if self.dx < 0 then
        self.direction = "left"
    elseif self.dx > 0 then
        self.direction ="right"
    end
end

function Player:animate(dt)
    self.animation.timer = self.animation.timer + dt
    if self.animation.timer > self.animation.rate then
        self.animation.timer = 0
        self:setNewFrame()
    end
end

function Player:setNewFrame()
    local anim = self.animation[self.State]
    if anim.current < anim.total then
       anim.current = anim.current + 1
    else
       anim.current = 1
    end
    self.animation.draw = anim.img[anim.current]
    
end

function Player:applyGravity(dt)
    if not self.grounded then
        self.dy = self.dy + self.gravity*dt
    end
end


function Player:move(dt)
    if love.keyboard.isDown("d", "right") then
       self.dx = math.min(self.dx + self.accleration * dt, self.maxspeed)
    elseif love.keyboard.isDown("a", "left") then
       self.dx = math.max(self.dx - self.accleration * dt, -self.maxspeed)
    else
       self:applyFriction(dt)
    end
 end

function Player:syncPhysics()
    self.x, self.y = self.physics.body:getPosition()
    self.physics.body:setLinearVelocity(self.dx,self.dy)
end

function Player:applyFriction(dt)
    if self.dx > 0 then
        if self.dx - self.friction*dt > 0 then
            self.dx = self.dx - self.friction*dt
        else
            self.dx = 0
        end
    elseif self.dx < 0 then
        if self.dx + self.friction*dt < 0 then
            self.dx = self.dx + self.friction*dt
        else
            self.dx = 0
        end
    end
end



function Player:beginContact (a,b,collision)
    if self.grounded == true then return end
    local nx,ny = collision:getNormal()
    if a == self.physics.fixture then
        if ny > 0 then
            self:land(collision)
        elseif ny < 0 then
            self.dy=0
        end
    elseif  b== self.physics.fixture then
        if ny < 0 then
            self:land(collision)
        elseif ny > 0 then
            self.dy=0
        end
    end
end

function Player:endContact (a,b,collision)
    if a == self.physics.fixture or b == self.physics.fixture then
        if self.collsionStatus == collision then
            self.grounded = false
        end
    end
end

function Player:tintRed()
    self.color.green = 0
    self.color.blue = 0
end


function Player:unTint(dt)
    self.color.red = math.min(self.color.red + self.color.speed*dt,1)
    self.color.green = math.min(self.color.green + self.color.speed*dt,1)
    self.color.blue= math.min(self.color.blue+ self.color.speed*dt,1)
end
function Player:draw()
    local scaleX = 0.08
    if self.direction == 'left' then
        scaleX = -0.08
    end
    love.graphics.setColor(self.color.red, self.color.green, self.color.blue)
    love.graphics.draw(self.animation.draw, self.x,self.y,0, scaleX, 0.08, self.animation.width/2,self.animation.height/2)
    love.graphics.setColor(1,1,1,1)
end

function Player:land(collision)
    self.collsionStatus = collision
    self.dy = 0
    self.grounded = true
end

function Player:jump(key)
    if (key == 'w' or key=='up') and self.grounded then
        self.dy = self.jumpHeight
        self.grounded = false
        Sound:play("jump","jump",1,1)
    end
end

function Player:success()
   Sound:play("success", "success",1,1,false)
end
    
return Player




