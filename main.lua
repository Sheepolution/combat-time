require "class"
require "game"
require "AnAl"
require "player"
require "level"
require "bullet"
require "menu"
require "bolt"

function love.load()
	love.graphics.setDefaultImageFilter("nearest", "nearest")
	m_pi    = math.pi
	m_atan2 = math.atan2
	m_abs   = math.abs
	m_ceil  = math.ceil
	m_floor = math.floor
	m_sqrt  = math.sqrt
	m_min   = math.min
	m_max   = math.max

	gamestate = "menu"

	fntScore =	love.graphics.newFont("font/pixel.TTF",40)

	menu_load()


	_=0

	
end

function love.update(dt)
	

	
	dt = m_min(0.01666667, dt)

	if (gamestate == "menu" or gamestate == "select") then
		menu_update(dt)
	end

	if (gamestate == "game") then
		game_update(dt)
	end

	mouseX = love.mouse.getX()
	mouseY = love.mouse.getY()


end

function love.draw()
	if (gamestate == "menu" or gamestate == "select") then
		menu_draw()
	elseif (gamestate == "game") then
		game_draw()
	end


end