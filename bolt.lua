bolt = class:new()
function bolt:init(x,y,from)
	self.tag = "bolt"
	self.player = from
	self.img = love.graphics.newImage("images/bolt.png")
	self.anim = newAnimation(self.img,96,93,0.1,0)
	self.posX, self.posY, self.w, self.h = x, y, 48, 46.5
	self.lifespan = 0
	self.state = "off"
	self.destroy = false
end

function bolt:update(dt)
	self.lifespan = self.lifespan + 1 * dt
	if (self.lifespan>=0.5) then
		self.anim:update(dt)
		self.state = "on"
	end

	if (self.anim:getCurrentFrame()==self.anim:getSize()) then
		self.destroy = true
	end


end

function bolt:draw()
	if (self.state == "on") then
		self.anim:draw(self.posX,self.posY,0,1,1,self.w,self.h)
	end

end

function  bolt:keypressed()
	-- body
end

function bolt:mousepressed( ... )
	-- body
end

function bolt:hit()

end