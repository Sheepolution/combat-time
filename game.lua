function game_load()

	imgWinner = love.graphics.newImage("images/winnerscreen.png")
	audioLevel = love.audio.newSource("audio/level.ogg")
	love.audio.play(audioLevel)

	gamestate = "game"
	levelstate = "count"
	pl1StartX = 100
	pl1StartY = 310
	pl2StartX = 800
	pl2StartY = 310
	reviewNumber = 1
	Level = level:new(20,10,1)
	Player1 = player:new(pl1StartX,pl1StartY,menu.playerOne,1)
	Player1.active = false
	Player2 = player:new(pl2StartX,pl2StartY,menu.playerTwo,2)
	Player2.active = false

	arrOfObjects = {Player1,Player2}
	arrOfDestruction = {}

	arrOfMovements1 = {arrOfX = {},arrOfY = {}, arrOfDir = {},arrOfState = {},arrOfButton = {},arrOfMX = {},arrOfMY = {}}
	arrOfMovements2 = {arrOfX = {},arrOfY = {}, arrOfDir = {},arrOfState = {},arrOfButton = {},arrOfMX = {},arrOfMY = {}}
	arrOfDT = {}

	cheat = false
	countNumber = 3
	playerGo = 1


end

function game_update(dt)

	if (gamestate == "game" and levelstate ~= "done") then
		if (audioLevel:isStopped()) then
			love.audio.rewind(audioLevel)
			love.audio.play(audioLevel)
			love.audio.stop(menu.audioMenu)
		end
	else
		love.audio.stop(audioLevel)
	end


	if (levelstate == "review") then
		reviewNumber = reviewNumber + 1

	end

	for i,v in pairs(arrOfObjects) do
		v:update(dt)
	end

	for i=1,#arrOfObjects do
		if (arrOfObjects[i].destroy) then
			table.insert(arrOfDestruction,i)
		end
	end

	for i=1,#arrOfDestruction do
		table.remove(arrOfObjects,arrOfDestruction[i])
	end

	arrOfDestruction = {}

	if (levelstate == "count") then
		countNumber = countNumber - 2 * dt
		if (countNumber<=0) then
			levelstate = "play"
			if (playerGo == 1) then Player1.active = true elseif(playerGo == 2) then Player2.active = true end
			countNumber = 10
		end
	end

	if (levelstate == "play") then
		countNumber = countNumber - 1 * dt
		if (playerGo == 1) then
			table.insert(arrOfMovements1.arrOfX,Player1.posX)
			table.insert(arrOfMovements1.arrOfY,Player1.posY)
			table.insert(arrOfMovements1.arrOfDir,Player1.dir)
			table.insert(arrOfMovements1.arrOfState,Player1.state)
			table.insert(arrOfMovements1.arrOfButton,Player1.buttonPressed)
			table.insert(arrOfMovements1.arrOfMX,Player1.mouseX)
			table.insert(arrOfMovements1.arrOfMY,Player1.mouseY)
			table.insert(arrOfDT,dt)

		end
		if (playerGo == 2) then
			table.insert(arrOfMovements2.arrOfX,Player2.posX)
			table.insert(arrOfMovements2.arrOfY,Player2.posY)
			table.insert(arrOfMovements2.arrOfDir,Player2.dir)
			table.insert(arrOfMovements2.arrOfState,Player2.state)
			table.insert(arrOfMovements2.arrOfButton,Player2.buttonPressed)
			table.insert(arrOfMovements2.arrOfMX,Player2.mouseX)
			table.insert(arrOfMovements2.arrOfMY,Player2.mouseY)
		end


		if (countNumber<=0) then
			if (playerGo == 1) then
				levelstate = "count"
				playerGo = 2
				Player1.active = false
				Player1.posX = pl1StartX
				Player1.posY = pl1StartY
				Player1.dir = 1
				Player1.state = "idle"

			elseif (playerGo == 2) then
				levelstate = "play"
				playerGo = 3
				Player2.active = false
				Player2.posX = pl2StartX
				Player2.posY = pl2StartY
				Player2.dir = -1
				Player2.state = "idle"

			elseif (playerGo == 3) then
				levelstate = "review"
			end
			countNumber = 3
		end
	end

	if (levelstate == "review") then
		if (reviewNumber >= #arrOfMovements1.arrOfX or reviewNumber >= #arrOfMovements2.arrOfX) then
			levelstate = "done"
		end

		for i=1,#arrOfObjects do
			for j=i+1,#arrOfObjects do
				local obj1,obj2 = arrOfObjects[i],arrOfObjects[j]
				if (obj1.char == "wrestler") then if (obj1.state == "attack") then obj1.w = 45 end end 
				if (obj2.char == "wrestler") then if (obj2.state == "attack") then obj2.w = 45 end end
				if (checkColl(obj1.posX,obj1.posY,obj1.w,obj1.h,obj2.posX,obj2.posY,obj2.w,obj2.h)) then
					obj1:hit(obj2)
					obj2:hit(obj1)
				end
			end
		end
	end
end



function game_draw()
	love.graphics.setColor(255,255,255)
	Level:draw()
	
	for i,v in pairs(arrOfObjects) do
		love.graphics.setColor(255,255,255)
		v:draw()
	end
	love.graphics.setColor(0,0,0)
	if (levelstate == "count") then
		love.graphics.print("Player" .. tostring(playerGo) .. " starting in..", 80, 100)
		love.graphics.print(m_ceil(countNumber), 450, 160)
	end
	if (levelstate == "play") then
		love.graphics.print(m_ceil(countNumber), 10, 10)
	end

	if (levelstate == "review") then
		love.graphics.print(Player1.damage, 10, 10)
		love.graphics.print(Player2.damage, 700, 10)
	end

	if (levelstate == "done") then
		love.graphics.setColor(255,255,255)
		love.graphics.draw(imgWinner, 0, 0)
		love.graphics.print(Player1.damage, 10, 10)
		love.graphics.print(Player2.damage, 700, 10)
		love.graphics.print("Enter to restart", 230,400)
		if (Player1.damage > Player2.damage) then
			love.graphics.print("PLAYER 2!!",290,100)
			if (Player2.char == "sergeant") then
				love.graphics.draw(menu.imgSergeant, 380, 130)
			end
			if (Player2.char == "wizard") then
				love.graphics.draw(menu.imgWizard, 380, 130)
			end
			if (Player2.char == "wrestler") then
				love.graphics.draw(menu.imgWrestler, 380, 130)
			end
		end
		if (Player2.damage > Player1.damage) then
			love.graphics.print("PLAYER 1!!", 290, 100)
			if (Player1.char == "sergeant") then
				love.graphics.draw(menu.imgSergeant, 480, 130)
			end
			if (Player1.char == "wizard") then
				love.graphics.draw(menu.imgWizard, 480, 130)
			end
			if (Player1.char == "wrestler") then
				love.graphics.draw(menu.imgWrestler, 380, 130)
			end
		end
		if (Player2.damage == Player1.damage) then
			love.graphics.print("TIE!!", 400, 100)
			if (Player1.char == "sergeant") then
				love.graphics.draw(menu.imgSergeant, 100, 130)
			end
			if (Player1.char == "wizard") then
				love.graphics.draw(menu.imgWizard, 100, 130)
			end
			if (Player1.char == "wrestler") then
				love.graphics.draw(menu.imgWrestler, 100, 130)
			end
			if (Player2.char == "sergeant") then
				love.graphics.draw(menu.imgSergeant, 900, 130,0,-1,1)
			end
			if (Player2.char == "wizard") then
				love.graphics.draw(menu.imgWizard, 900, 130,0,-1,1)
			end
			if (Player2.char == "wrestler") then
				love.graphics.draw(menu.imgWrestler, 900, 130,0,-1,1)
			end
		end
	end



end

function keyCheck(key)
	if (key == 'walkLeft') then
		if (love.keyboard.isDown('left') or love.keyboard.isDown('a')) then
			return true
		else
			return false
		end
	elseif (key == 'walkRight') then
		if (love.keyboard.isDown('right') or love.keyboard.isDown('d')) then
			return true
		else
			return false
		end
	elseif (love.keyboard.isDown(key)) then
		return true
	end
end


function love.keyreleased(key)

	if (gamestate == "game") then

	end

end

function love.keypressed(key)

	if (gamestate == "game") then
		for i,v in pairs(arrOfObjects) do
			v:keypressed(key)
		end
	end

	if (gamestate == "menu") then
		if (key=="return") then
			gamestate = "select"
			love.audio.play(menu.audioConfirm)
		end
	end

	if (gamestate == "game" and levelstate == "done") then
		if (key == 'return') then
			gamestate = "menu"
			menu_load()
		end
	end

	if (key == "f10") then
		cheat = true
	end


end

function mouseCheck(button)

	if (love.mouse.isDown(button)) then
		return true
	end

end

function love.mousepressed(x,y,button)

	if (gamestate == "game") then

		for i,v in pairs(arrOfObjects) do
			v:mousepressed(x,y,button)
		end

	end

	menu_mousepressed(x,y,button)

	


end

function love.mousereleased(x,y,button)



end

function checkSolid(x,y,w,h,prevX,prevY) --Check if the object is hitting a solid tile
 	
	local gotHit,hitBot, hitTop, hitLeft, hitRight, tileNumber = false, false, false, false, false, 0

	--Go through all solid tiles
	for i=1,#Level.solid.map do
		if Level.solid.map[i] ~=0 and Level.solid.map[i] ~=8 and Level.solid.map[i] ~=12 and Level.solid.map[i] ~=16  then
			tileNumber = Level.solid.map[i]
			local tileX = getTile(i,"posX")
			local tileY = getTile(i,"posY")
			local tW = Level.solid.tileWidth/2
			local tH = Level.solid.tileHeight/2

			if (tileNumber == 6) then
				tileY = getTile(i,"posY")+tH-40
				tH = 4
			elseif (tileNumber == 9) then
				tileX = getTile(i,"posX")+tW-40
				tW = 4
			elseif (tileNumber == 11) then
				tileX = getTile(i,"posX")-tW+40
				tW = 4
			elseif (tileNumber == 14) then
				tileY = getTile(i,"posY")-tH+40
				tH = 4
			end

			--Check for any collisions, using the previous y positions to prevent double collision.
			local hit,hitL, hitR, hitT, hitB = checkCollision(x,prevY,w,h,tileX,tileY,tW,tH)

			if (hit) then
				gotHit = true
			end

			if (hitL or hitR) then
				--When hitting horizontal
				if (hitL) then
					-- When hitting the left side
					-- Push the object back so it's x is against the wall, instead of inside it.
					x = x + ((tileX + tW) - (x-w))
					hitLeft = true

				end
				if (hitR) then
					-- When hitting the left side
					-- Push the object back so it's x is against the wall, instead of inside it.
					x = x - ((x+w) - (tileX - tW))
					hitRight = true
				end
			end

			local hit, hitL, hitR, hitT, hitB = checkCollision(prevX,y,w,h,tileX,tileY,tW,tH)

			if (hit) then
				gotHit = true
			end

			-- When hitting vertical
			if (hitT or hitB) then
				if (hitT) then
					y = y + ((tileY + tH) - (y-h))
					hitTop = true
				end
				if (hitB) then
					y = y - ((y+h) - (tileY - tH))
					hitBot = true
				end
			end
		end
	end

	return gotHit,x,y,hitBot,hitTop
end

function checkCollision(x1,y1,w1,h1,x2,y2,w2,h2)
	local hit, hitLeft, hitRight, hitTop, hitBot = false, false, false, false, false
	local bbleft1, bbright1, bbup1, bbdown1, bbleft2, bbright2, bbup2, bbdown2 = x1 - w1, x1 + w1, y1 - h1, y1 + h1, x2 - w2, x2 + w2, y2 - h2, y2 + h2
	if (bbright1 > bbleft2 and bbleft1 < bbright2) and (bbup1 < bbdown2 and bbdown1 > bbup2) then
		hit = true
		if (bbup1 < bbdown2 and bbdown1 > bbdown2) then
			hitTop = true
		end
		if (bbleft1 < bbright2 and bbright1 > bbright2) then
			hitLeft = true
		end
		if (bbdown1 > bbup2 and bbup1 < bbup2) then
			hitBot = true
		end
		if (bbright1 > bbleft2 and bbleft1 < bbleft2) then
			hitRight = true
		end
	end
	return hit,hitLeft,hitRight,hitTop,hitBot
end

function checkColl(x1,y1,w1,h1,x2,y2,w2,h2)
	if (x1 ~= nil and x2 ~= nil) then
		local bbleft1, bbright1, bbup1, bbdown1, bbleft2, bbright2, bbup2, bbdown2 = x1 - w1, x1 + w1, y1 - h1, y1 + h1, x2 - w2, x2 + w2, y2 - h2, y2 + h2
		return (bbright1 > bbleft2 and bbleft1 < bbright2) and (bbup1 < bbdown2 and bbdown1 > bbup2)
	else
		return false
	end
end

function getTile(i,c) 
	-- Returns the x and y position of the tile.
	if c == "posX" then
		return ((i-1) % Level.length)*Level.solid.tileWidth+Level.solid.tileHeight/2
	end
	if c == "posY" then
		return m_floor((i-1)/Level.length)*Level.solid.tileHeight+Level.solid.tileHeight/2
	end
end

function getDistance(x1,y1,x2,y2)
	local dx = m_abs(x1-x2)
	local dy = m_abs(y1-y2)
	return m_sqrt(dx^2 + dy^2)
end
