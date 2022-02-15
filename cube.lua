local Cube = {img = love.graphics.newImage("png/Object/Cube.png")}
Cube.__index = Cube
Cube.width = Cube.img:getWidth()
Cube.height = Cube.img:getHeight()
local ActiveCube = {}
function Cube.new(x,y)
    local instance = setmetatable({}, Cube)
    instance.x = x
    instance.y = y

    instance.physics = {}
    instance.physics.body = love.physics.newBody(World,instance.x, instance.y,"dynamic")
    instance.physics.shape = love.physics.newRectangleShape(instance.width,instance.height)
    instance.physics.fixture = love.physics.newFixture(instance.physics.body,instance.physics.shape)
    instance.physics.body:setMass(6)
    table.insert(ActiveCube,instance)
end

function Cube:update(dt)
    self:syncPhysics()
end

function Cube:syncPhysics()
    self.x, self.y =self.physics.body:getPosition()
    self.r = self.physics.body:getAngle()
end

function Cube.updateAll(dt)
    for i,instance in ipairs(ActiveCube) do
        instance:update(dt)
    end
end

function Cube:draw()
    love.graphics.draw(self.img,self.x,self.y,self.r, self.scaleX,1,self.width/2, self.height/2)
end

function Cube.drawAll()
    for i,instance in ipairs(ActiveCube) do
        instance:draw()
    end
end

function Cube:removeAll()
    for i,v in ipairs(ActiveCube) do
        v.physics.body:destroy()
    end
    ActiveCube = {}
end


return Cube