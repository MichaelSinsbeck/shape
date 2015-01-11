local menu = {}
local selection = 1
local options
local textcolor = 1
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
	textcolor = love.math.random(#color)
	while textcolor == cursor.color do
		textcolor = love.math.random(#color)
	end
	state = 'menu'
end

function menu.draw()
	love.graphics.setFont(largeFont)
	local r,g,b = color[textcolor][1],color[textcolor][2],color[textcolor][3]
	love.graphics.setColor(r,g,b)
	for k,v in ipairs(options) do
		love.graphics.printf(v.caption,150,k*60,350,'left')
	end
	drawShape(100,selection*60+30,cursor.color,cursor.shape,cursor.fill,0.5)
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
