player = class:new()
function player:init(x,y,c,p)
	self.tag = "player"
	self.active = true
	self.state = "idle"
	self.destroy = false
	self.char = c
	self.player = p
	self.imgStand,self.animWalk, self.animAttack ,self.attackTime, self.attackSpeed, self.speed, self.jumpHeight,self.jumpFrame,self.w, self.h,self.xOff,self.yOff = self:getCharacter(self.char)
	self.posX, self.posY = x, y
	self.prevX, self.prevY = self.posX, self.posY
	self.velocity = 0
	self.grav = 2000
	self.temp = 0
	self.hitSolid = false
	self.onGround = false
	self.hitHead = false
	self.jumping = 1
	self.atkTimer = 0.3
	self.currentSpeed = self.speed
	self.countNumber = 1
	self.mouseX = mouseX
	self.mouseY = mouseY
	self.buttonPressed = ' '
	self.countNumber = 1
	self.damage = 0
	self.invincible = 0

	self.audioJump = love.audio.newSource("audio/jump.ogg","static")
	self.audioSlam = love.audio.newSource("audio/bodyslam.ogg","static")
	self.audioBolt = love.audio.newSource("audio/bolt.ogg","static")
	self.audioShoot = love.audio.newSource("audio/shoot.ogg","static")

	if (self.player == 1) then self.dir = 1 else self.dir = -1 end

end

function player:update(dt)

	if (levelstate == "play") then

		if (self.active) then

			self.mouseX = mouseX
			self.mouseY = mouseY

			if (keyCheck('walkRight')) then
				
				self.posX = self.posX + self.currentSpeed * dt
				self.dir = 1
				if (self.state ~= "attack") then
					self.state = "walk"
				end
			end

			if (keyCheck('walkLeft')) then
				self.posX = self.posX - self.currentSpeed * dt
				self.dir = -1
				if (self.state ~= "attack") then
					self.state = "walk"
				end
			end

			if (((keyCheck('walkLeft') and keyCheck('walkRight')) or (keyCheck('walkLeft')==false and keyCheck('walkRight')==false)) and self.state~="attack") then
				self.state = "idle"
			end

			--Vertical movement
			self.temp = self.grav*dt
			self.posY = self.posY + dt*(self.velocity + self.temp/2)
			self.velocity = self.velocity + self.temp

			self.hitSolid, self.posX, self.posY, self.onGround, self.hitHead = checkSolid(self.posX,self.posY,self.w,self.h,self.prevX,self.prevY)

			if (self.onGround) then
				self.velocity = 0
				self.jumping = 1
			else
				if (self.state ~= "attack") then
					self.state = "jump"
				end
				self.animWalk:seek(self.jumpFrame)
			end

			if (self.hitHead) then
				self.velocity = 0
			end

			self.prevX, self.prevY = self.posX, self.posY

			if (self.state == "attack") then
				self.currentSpeed = self.attackSpeed
				
				if (self.animAttack:getCurrentFrame()==self.animAttack:getSize()) then
					self.state = "idle"
					self.animAttack:seek(1)
				end
			else
				self.currentSpeed = self.speed
			end

			if (self.char == "sergeant") then
				self.atkTimer = self.atkTimer + 1 * dt
			end
		end
	elseif (levelstate == "review") then

		if (self.invincible>0) then
			self.invincible=self.invincible-1*dt
		else
			self.invincible = 0
		end

		if (self.player == 1) then
			local numb = m_floor(reviewNumber)
			self.posX = arrOfMovements1.arrOfX[numb]
			self.posY = arrOfMovements1.arrOfY[numb]
			self.dir = arrOfMovements1.arrOfDir[numb]
			self.state = arrOfMovements1.arrOfState[numb]
			self.buttonPressed = arrOfMovements1.arrOfButton[numb]
			self.mouseX = arrOfMovements1.arrOfMX[numb]
			self.mouseY = arrOfMovements1.arrOfMY[numb]
		end

		if (self.player == 2) then
			local numb = m_floor(reviewNumber)
			self.posX = arrOfMovements2.arrOfX[numb]
			self.posY = arrOfMovements2.arrOfY[numb]
			self.dir = arrOfMovements2.arrOfDir[numb]
			self.state = arrOfMovements2.arrOfState[numb]
			self.buttonPressed = arrOfMovements2.arrOfButton[numb]
			self.mouseX = arrOfMovements2.arrOfMX[numb]
			self.mouseY = arrOfMovements2.arrOfMY[numb]
		end

	end

	if (self.state == "walk") then
		self.animWalk:update(dt)
	end
	if (self.state == "jump") then
		self.animWalk:seek(self.jumpFrame)
	end
	if (self.state == "attack") then
		self.animAttack:update(dt)
	end

	if (self.buttonPressed =='x') then
		self:attack()
		self.buttonPressed = ' '
	end

end

function player:draw()
	if (self.active or levelstate == "review") then
		if (self.state == "walk" or self.state == "jump") then
			self.animWalk:draw(self.posX,self.posY,0,self.dir,1,self.w+self.xOff,self.h+self.yOff)
		end

		if (self.state == "idle") then
			love.graphics.draw(self.imgStand, self.posX, self.posY, 0, self.dir, 1, self.w+self.xOff, self.h+self.yOff)
		end

		if(self.state == "attack") then
			self.animAttack:draw(self.posX,self.posY,0,self.dir,1,self.w+self.xOff,self.h+self.yOff)
		end
	else
		love.graphics.setColor(100,100,100)
		love.graphics.draw(self.imgStand, self.posX, self.posY, 0, self.dir, 1, self.w+self.xOff, self.h+self.yOff)
	end
end

function player:keypressed(key)
	if (self.active) then
		if (self.state~="attack") then
			if (key == 'z' or key == 'w') then
				self:jump()
			end
			if (key == 'x') then
				self.buttonPressed = 'x'
				if (self.player == 1) then
					table.insert(arrOfMovements1.arrOfButton,Player1.buttonPressed)
				end
				if (self.player == 2) then
					table.insert(arrOfMovements2.arrOfButton,Player2.buttonPressed)
				end
			end
		end
	end
end

function player:mousepressed(x,y,button)
	if (self.active) then
		if (self.state~="attack") then
			if (button == 'l') then
				self.buttonPressed = 'x'
				if (self.player == 1) then
					table.insert(arrOfMovements1.arrOfButton,Player1.buttonPressed)
				end
				if (self.player == 2) then
					table.insert(arrOfMovements2.arrOfButton,Player2.buttonPressed)
				end
			end
		end
	end
end

function player:attack()

	if (self.char == "wizard") then
		self.state = "attack"
		self:bolt(self.mouseX,self.mouseY)
	elseif (self.char == "wrestler") then
		self.state = "attack"
	elseif (self.char == "sergeant") then
		self:shoot()
	end


end

function player:jump()

	if (self.jumping == 1 or cheat) then
		self.jumping = 0
		self.velocity = -self.jumpHeight
		self.animWalk:seek(self.jumpFrame)
		self.state = "jump"
		self.jumping = 0
	end

end

function player:shoot()
		table.insert(arrOfObjects,bullet:new(self.posX+50*self.dir,self.posY+5,self.dir,self.player))
		love.audio.play(self.audioShoot)

end

function player:bolt(x,y)
	table.insert(arrOfObjects,bolt:new(x,y,self.player))
	love.audio.play(self.audioBolt)
end

function player:getCharacter(char)

	if (char == "sergeant") then
		return love.graphics.newImage("images/sergeantStand.png"),newAnimation(love.graphics.newImage("images/sergeantWalk.png"),69, 90, 0.1, 0),newAnimation(love.graphics.newImage("images/sergeantWalk.png"),69, 90, 0.1, 0), 0.1,280,260,700,3,22, 45,0,0
	end

	if (char == "wizard") then
		return love.graphics.newImage("images/wizardStand.png"),newAnimation(love.graphics.newImage("images/wizardWalk.png"),96, 114, 0.3, 0),newAnimation(love.graphics.newImage("images/wizardAttack.png"),99, 114, 0.1, 0),0,0,240,800,1,22, 30,0,53
	end

	if (char == "wrestler") then
		return love.graphics.newImage("images/wrestlerStand.png"),newAnimation(love.graphics.newImage("images/wrestlerWalk.png"),57, 90, 0.1, 0),newAnimation(love.graphics.newImage("images/wrestlerAttack.png"),90, 90, 0.1, 0),0,225,400,700,4,22, 45,0,0
	end
	

end

function player:hit(b)
	if (b.tag == 'bullet') then
		if (b.player~=self.player) then
			self.damage = self.damage + 1
			b.destroy = true
		end
	end
	if (b.tag == "player") then
		if (b.char == "wrestler") then
			if (b.state == "attack") then
				if (self.invincible == 0) then
					love.audio.play(self.audioSlam)
					self.damage = self.damage + 10
					self.invincible = 1.5
				end
			end
		end
	end
	if (b.tag == "bolt") then
		if (b.state == "on") then
			if (b.player~=self.player) then
				if (self.invincible == 0) then
					self.damage = self.damage + 10
					self.invincible = 1.5
				end
			end
		end
	end
end