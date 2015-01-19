local explanation = {}
local button
local aboutToQuit

function explanation.goto()

	if level >= #stages then
		states.highscore.goto()
		return
	end
	level = level + 1
	local levelLength = math.min(48,level*8)
	thisLevel = generateLevel(stages,level,levelLength)
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
		myPrint('Instructions',0,20,500,'center')
		love.graphics.setColor(colorFG)		
		love.graphics.setFont(smallFont)
		myPrint('Sort the shapes with left/q and right/p\n\nForgot the shapes? Press "tab"\n\nBe fast and accurate for higher score',0,120,500,'center')		
	end
	love.graphics.setColor(colorFG)
	local v = stages[level]
	if v.direction == 1 then
		button = 'left/q'
	else
		button = 'right/p'
	end

	--love.graphics.setFont(largeFont)
	--myPrint('New shape goes ' .. button,0,240,500,'center')
	
	if aboutToQuit then
		love.graphics.setFont(tinyFont)
		myPrint('Press esc again to quit',2,2,498,'left')
	end
	
	-- press to continue
	love.graphics.setFont(smallFont)
	myPrint('Press ' .. button ..' to continue',0,352,500,'center')
	
	-- Box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',xleft,380,xwidth,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(xleft,380,xleft+xwidth,380)
	

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
		if not aboutToQuit and level>1 then
			aboutToQuit = true
		else
			states.modeselect.goto()
			playSound('back')
		end
	else
		aboutToQuit = false
	end
	local v = stages[level]
	if v.direction == 1 and (key=='left' or key=='q') then
		playSound('select')
		states.game.goto()
	end
	if v.direction == 2 and (key=='right' or key=='p') then
		playSound('select')
		states.game.goto()
	end	
end

return explanation
