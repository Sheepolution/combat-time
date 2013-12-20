function menu_load()
	menu = {
	imgStart = love.graphics.newImage("images/startscreen.png"),
	imgMenu = love.graphics.newImage("images/menuscreen.png"),
	imgSelect = love.graphics.newImage("images/selectscreen.png"),

	imgSergeant = love.graphics.newImage("images/bigSergeant.png"),
	imgWizard = love.graphics.newImage("images/bigWizard.png"),
	imgWrestler = love.graphics.newImage("images/bigWrestler.png"),

	imgSergeantText = love.graphics.newImage("images/textSergeant.png"),
	imgWizardText = love.graphics.newImage("images/textWizard.png"),
	imgWrestlerText = love.graphics.newImage("images/textWrestler.png"),

	audioSelect = love.audio.newSource("audio/select.ogg","static"),
	audioConfirm = love.audio.newSource("audio/confirm.ogg","static"),
	audioMenu = love.audio.newSource("audio/menu.ogg"),

	charLocked = "none",

	playerSelect = 1,

	playerOne = "none",
	playerTwo = "none"
	}

	love.audio.play(menu.audioMenu)

	imgStartTimer = 1.6



end

function menu_update(dt)

	imgStartTimer = imgStartTimer - 1 * dt
	

	if (gamestate == "menu" or gamestate == "select") then
		if (menu.audioMenu:isStopped()) then
			love.audio.rewind(menu.audioMenu)
			love.audio.play(menu.audioMenu)
			love.audio.stop(audioLevel)
		end
	else
		love.audio.stop(menu.audioMenu)
	end

	


end

function menu_draw()
	love.graphics.setFont(fntScore)
	if (keyCheck('f1')) then
		love.graphics.draw(menu.imgStart, 0, 0)
	elseif (gamestate == "menu") then
		love.graphics.setBackgroundColor(34,177,76)
		love.graphics.draw(menu.imgMenu,0,0,0,1,1)
		
		love.graphics.print("PRESS ENTER",250,300)
	elseif (gamestate == "select") then
		love.graphics.draw(menu.imgSelect,0,0)
		if (menu.playerSelect == 1) then
			if (menu.playerOne == "none") then
				if (checkCollision(mouseX,mouseY,0,0,378,221,36,36)) then
					love.graphics.draw(menu.imgWrestler,10,140)
					love.graphics.draw(menu.imgWrestlerText,12,35)
				end

				if (checkCollision(mouseX,mouseY,0,0,474,221,36,36)) then
					love.graphics.draw(menu.imgSergeant,10,140)
					love.graphics.draw(menu.imgSergeantText,15,35)
				end

				if (checkCollision(mouseX,mouseY,0,0,571,221,36,36)) then
					love.graphics.draw(menu.imgWizard,20,140)
					love.graphics.draw(menu.imgWizardText,45,35)
				end
			end
		end

		if (menu.playerSelect == 2) then
			if (menu.playerTwo == "none") then
				if (checkCollision(mouseX,mouseY,0,0,378,221,36,36)) then
					love.graphics.draw(menu.imgWrestler,950,139,0,-1,1)
					love.graphics.draw(menu.imgWrestlerText,640,35)
				end

				if (checkCollision(mouseX,mouseY,0,0,474,221,36,36)) then
					love.graphics.draw(menu.imgSergeant,930,140,0,-1,1)
					love.graphics.draw(menu.imgSergeantText,640,35)
				end

				if (checkCollision(mouseX,mouseY,0,0,571,221,36,36)) then
					love.graphics.draw(menu.imgWizard,930,140,0,-1,1)
					love.graphics.draw(menu.imgWizardText,680,35)
				end
			end
		end

		if (menu.playerOne == "wrestler") then
			love.graphics.draw(menu.imgWrestler,10,140)
			love.graphics.draw(menu.imgWrestlerText,12,35)
		elseif (menu.playerOne == "sergeant") then
			love.graphics.draw(menu.imgSergeant,10,140)
			love.graphics.draw(menu.imgSergeantText,15,35)
		elseif (menu.playerOne == "wizard") then
			love.graphics.draw(menu.imgWizard,20,140)
			love.graphics.draw(menu.imgWizardText,45,35)
		end
		if (menu.playerTwo == "wrestler") then
			love.graphics.draw(menu.imgWrestler,950,139,0,-1,1)
			love.graphics.draw(menu.imgWrestlerText,640,35)
		elseif (menu.playerTwo == "sergeant") then
			love.graphics.draw(menu.imgSergeant,930,140,0,-1,1)
			love.graphics.draw(menu.imgSergeantText,640,35)
		elseif (menu.playerTwo == "wizard") then
			love.graphics.draw(menu.imgWizard,930,140,0,-1,1)
			love.graphics.draw(menu.imgWizardText,680,35)
		end

	end



end


function menu_mousepressed(x,y,button)
	if (gamestate == "select") then 
		if (menu.playerSelect == 1) then
			if (checkCollision(x,y,0,0,378,221,36,36)) then
				menu.playerOne = "wrestler"
				love.audio.play(menu.audioSelect)
			end

			if (checkCollision(x,y,0,0,474,221,36,36)) then
				menu.playerOne = "sergeant"
				love.audio.play(menu.audioSelect)
			end

			if (checkCollision(x,y,0,0,571,221,36,36)) then
				menu.playerOne = "wizard"
				love.audio.play(menu.audioSelect)
			end

			if (checkCollision(x,y,0,0,162,433,157,29) and menu.playerOne ~= "none") then
				menu.playerSelect = 2
			end
		end

		if (menu.playerSelect == 2) then
			if (checkCollision(x,y,0,0,378,221,36,36)) then
				menu.playerTwo = "wrestler"
				love.audio.play(menu.audioSelect)
			end

			if (checkCollision(x,y,0,0,474,221,36,36)) then
				menu.playerTwo = "sergeant"
				love.audio.play(menu.audioSelect)
			end

			if (checkCollision(x,y,0,0,571,221,36,36)) then
				menu.playerTwo = "wizard"
				love.audio.play(menu.audioSelect)
			end
			if (checkCollision(x,y,0,0,689,433,157,29) and menu.playerTwo ~= "none") then
				game_load()
				gamestate = "game"
				love.audio.stop(menu.audioMenu)
			end

		end
	end

end