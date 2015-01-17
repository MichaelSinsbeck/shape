local custom = {}
local selection = 1

function custom.goto()
	selection = 1
	cursor = {}
	cursor.shape = love.math.random(#outline)
	cursor.color = love.math.random(#color)
	cursor.fill = love.math.random(2)	
	state = 'custom'
end

function custom.draw()
	-- Box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',xleft,380,xwidth,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(xleft,380,xwidth,380)	

	-- Explanation
	love.graphics.setFont(tinyFont)
	love.graphics.setColor(colorFG)
	love.graphics.printf('left/right - change value',0,353,500,'center')
	love.graphics.printf('return - start game',0,363,500,'center')
	
	-- Descriptions
	local maxLevels = math.min(customMode.nColor*customMode.nShape*customMode.nFill,16)
	love.graphics.setFont(smallFont)

	love.graphics.printf('Levels',0,385,165,'right')
	love.graphics.printf(customMode.nLevels,200,385,200,'left')
	love.graphics.printf('Colors',0,410,165,'right')
	love.graphics.printf('Shapes',0,435,165,'right')
	love.graphics.printf('Styles',0,460,165,'right')
	love.graphics.printf('Order',0,485,165,'right')
	if customMode.isRandom then
		love.graphics.printf('random',200,485,200,'left')
	else
		love.graphics.printf('stratified (easy)',200,485,200,'left')
	end

	
	drawShape(182,selection*25+372, cursor.color,cursor.shape,cursor.fill,0.2)
	
	love.graphics.setLineWidth(2)
	love.graphics.setColor(colorFG)	
	for i=1,#color do
		love.graphics.rectangle('line',200+(i-1)*19,416,15,15)
	end
	for i=1,#outline do
		love.graphics.rectangle('line',200+(i-1)*19,441,15,15)
	end
	for i=1,2 do
		love.graphics.rectangle('line',200+(i-1)*19,466,15,15)
	end
	
	for i=1,customMode.nColor do
		love.graphics.rectangle('fill',200+(i-1)*19,416,15,15)
	end
	for i=1,customMode.nShape do
		love.graphics.rectangle('fill',200+(i-1)*19,441,15,15)
	end
	for i=1,customMode.nFill do
		love.graphics.rectangle('fill',200+(i-1)*19,466,15,15)
	end
end

function custom.update(dt)
end

function custom.keypressed(key)
	local nOptions = 5
	if key == 'down' then
		selection = (selection%nOptions)+1
		playSound('move')
	elseif key == 'up' then
		selection = ((selection-2)%nOptions)+1
		playSound('move')
	elseif key == 'escape' then
		states.modeselect.goto()
		playSound('back')
		saveState()		
	elseif key == 'left' then
		if selection == 1 then
			customMode.nLevels = math.max(customMode.nLevels-1,1)
		elseif selection == 2 then
			customMode.nColor = math.max(customMode.nColor-1,1)
		elseif selection == 3 then
			customMode.nShape = math.max(customMode.nShape-1,1)
		elseif selection == 4 then
			customMode.nFill = math.max(customMode.nFill-1,1)
		elseif selection == 5 then
			customMode.isRandom = not customMode.isRandom
		end
		local maxLevels = math.min(customMode.nColor*customMode.nShape*customMode.nFill,16)
		customMode.nLevels = math.min(customMode.nLevels,maxLevels)
	elseif key == 'right' then
		if selection == 1 then
			customMode.nLevels = customMode.nLevels + 1
		elseif selection == 2 then
			customMode.nColor = math.min(customMode.nColor+1,8)
		elseif selection == 3 then
			customMode.nShape = math.min(customMode.nShape+1,8)
		elseif selection == 4 then
			customMode.nFill = math.min(customMode.nFill+1,2)
		elseif selection == 5 then
			customMode.isRandom = not customMode.isRandom			
		end
		local maxLevels = math.min(customMode.nColor*customMode.nShape*customMode.nFill,16)
		customMode.nLevels = math.min(customMode.nLevels,maxLevels)
	elseif key == 'return' then
		playSound('select')
		saveState()		
		stages = newOrder(customMode.nColor, customMode.nShape, customMode.nFill, customMode.nLevels)
			newGame()
	end
end

return custom
