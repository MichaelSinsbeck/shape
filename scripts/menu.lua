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
		saveState()		
		if soundOn then
			options[2].caption = 'sound: on'
		else
			options[2].caption = 'sound: off'
		end
	end
	local thisCaption
	if soundOn then
		thisCaption = 'sound: on'
	else
		thisCaption = 'sound: off'
	end
	table.insert(options,{caption = thisCaption, fun = soundFun})

	-- fullscreen
	local fullscreenFun = function()
		fullscreen = not fullscreen
		saveState()	
		if fullscreen then
			options[3].caption = 'fullscreen: on'
		else
			options[3].caption = 'fullscreen: off'
		end
		makeWindow()
	end
	local thisCaption
	if fullscreen then
		thisCaption = 'fullscreen: on'
	else
		thisCaption = 'fullscreen: off'
	end
	table.insert(options,{caption = thisCaption, fun = fullscreenFun})
			
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
	-- title line
	love.graphics.setFont(largeFont)
	love.graphics.setColor(colorEmph)
	myPrint('Shape and Color',0,20,500,'center')
	
	-- options and cursor
	love.graphics.setColor(colorFG)
	for k,v in ipairs(options) do
		myPrint(v.caption,180,k*50+50,350,'left')
	end
	drawShape(120,selection*50+23+60
	,cursor.color,cursor.shape,cursor.fill,0.4)
	
	-- box at the bottom
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',xleft,380,xwidth,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(xleft,380,xleft+xwidth,380)
	
	love.graphics.setColor(colorEmph)
	love.graphics.draw(logo,410,450,0,.5,.5,100,100)
	love.graphics.setColor(colorFG)
	love.graphics.setFont(smallFont)
	myPrint('A game by Michael Sinsbeck',0,470,400,'center')
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
