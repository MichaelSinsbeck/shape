local explanation = {}
local button
local aboutToQuit

function explanation.goto()

	if level >= #stages then
		states.highscore.goto()
		return
	end
	level = level + 1
	thisLevel = generateLevel(stages,level,level*8)
	state = 'explanation'
	started = false
	aboutToQuit = false
end

function explanation.draw()
	if level > 1 then
		states.game.drawOrder()
	else
		love.graphics.setColor(colorEmph)
		love.graphics.setFont(largeFont)
		love.graphics.printf('Instructions',0,20,500,'center')
		love.graphics.setColor(colorFG)		
		love.graphics.setFont(smallFont)
		love.graphics.printf('Sort the shapes with "left" and "right"\n\nForgot the shapes? Press "tab"\n\nBe fast and accurate for higher score',0,120,500,'center')		
	end
	love.graphics.setColor(colorFG)
	local v = stages[level]
	if v.direction == 1 then
		button = 'left'
	else
		button = 'right'
	end

	--love.graphics.setFont(largeFont)
	--love.graphics.printf('New shape goes ' .. button,0,240,500,'center')
	
	if aboutToQuit then
		love.graphics.setFont(tinyFont)
		love.graphics.printf('Press "esc" again to quit',2,2,498,'left')
	end
	
	-- press to continue
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "' .. button ..'" to continue',0,352,500,'center')
	
	-- Box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',0,380,500,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(0,380,500,380)		
	

	drawShape(250,450,v.color,v.shape,v.fill,1)
	
	-- arrow
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(8)
	if v.direction == 1 then
		love.graphics.polygon('line',
			150,430,100,430,100,410,50,450,
			100,490,100,470,150,470)
	else
		love.graphics.polygon('line',
			350,430,400,430,400,410,450,450,
			400,490,400,470,350,470)
	end	

end

function explanation.update(dt)
end

function explanation.keypressed(key)
	if key == 'escape' then
		if not aboutToQuit then
			aboutToQuit = true
		else
			states.modeselect.goto()
		end
	else
		aboutToQuit = false
	end
	if key == button then
		playSound('check')
		states.game.goto()
	end
end

return explanation
