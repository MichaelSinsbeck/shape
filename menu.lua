local menu = {}
local selection = 1
local options
local cursor

function menu.init()
	options = {}
	-- start
	local startFun = function() states.modeselect.goto() end
	table.insert(options,{caption = 'play',fun = startFun})
	
	-- sound
	local soundFun = function()
		soundOn = not soundOn
		if soundOn then
			options[2].caption = 'sound: on'
		else
			options[2].caption = 'sound: off'
		end
	end
	table.insert(options,{caption = 'sound: on', fun = soundFun})
	
	-- exit
	local endFun = function() love.event.quit() end
	table.insert(options,{caption = 'quit', fun = endFun})
end

function menu.goto()
	menu.init()
	selection = 1
	cursor = {}
	cursor.shape = love.math.random(#outline)
	cursor.color = love.math.random(#color)
	cursor.fill = love.math.random(2)
	state = 'menu'
end

function menu.draw()
	love.graphics.setFont(largeFont)
	love.graphics.setColor(colorEmph)
	love.graphics.printf('Shape and Color',0,20,500,'center')
	
	love.graphics.setColor(colorFG)
	for k,v in ipairs(options) do
		love.graphics.printf(v.caption,200,k*50+50,350,'left')
	end
	drawShape(140,selection*50+23+60
	,cursor.color,cursor.shape,cursor.fill,0.4)
	
	-- box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',0,380,500,140)	
	
	love.graphics.setColor(colorEmph)
	love.graphics.draw(logo,410,450,0,1,1,50,50)
	love.graphics.setColor(colorFG)
	love.graphics.setFont(smallFont)
	love.graphics.printf('A game by Michael Sinsbeck',0,470,400,'center')
end

function menu.update(dt)
end

function menu.keypressed(key)
	local nOptions = #options
	if key == 'down' then
		selection = (selection%nOptions)+1
		playSound('move')
	elseif key == 'up' then
		selection = ((selection-2)%nOptions)+1
		playSound('move')
	elseif key == 'escape' then
		love.event.quit()
	elseif key == 'return' or key == ' ' then
		options[selection].fun()
		playSound('select')
	end
end

return menu
