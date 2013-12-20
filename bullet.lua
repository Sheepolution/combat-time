bullet = class:new()
function bullet:init(x,y,d,from)
	self.tag = "bullet"
	self.player = from
	self.destroy = false
	self.img = love.graphics.newImage("images/bullet.png")
	self.posX, self.posY, self.w, self.h = x, y, self.img:getWidth()/2, self.img:getHeight()/2
	self.speed = 800
	self.dir = d
	self.hitSolid = false

end

function bullet:update(dt)

	self.posX = self.posX + self.speed*self.dir*dt

	self.hitSolid,_,_,_,_ = checkSolid(self.posX,self.posY,self.w,self.h,self.posX,self.posY)
	if (self.hitSolid) then

		self.destroy = true

	end


end

function bullet:draw()

	love.graphics.draw(self.img,self.posX,self.posY,0,1,1,self.w,self.h)

end

function bullet:keypressed(key)

end

function bullet:mousepressed()
	-- body
end

function bullet:hit(b)

	if (b.tag == "player") then
		self.destroy = true
	end
end