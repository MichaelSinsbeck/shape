local modeselect = {}
local selection = 1
local modi
local cursor
customMode = {
		name = 'custom',
		nColor = 1,
		nShape = 1,
		nFill = 1,
		nLevels = 1
		}

function modeselect.init()
	modi = {}
	local modus = {
		name = 'color',
		nColor = 8,
		nShape = 1,
		nFill = 1,
		nLevels = 8
		}
	table.insert(modi,modus)
	
	modus = {
		name = 'shape',
		nColor = 1,
		nShape = 8,
		nFill = 1,
		nLevels = 8
		}
	table.insert(modi,modus)
	modus = {
		name = 'mixed',
		nColor = 2,
		nShape = 2,
		nFill = 2,
		nLevels = 8
		}
	table.insert(modi,modus)	
	modus = {
		name = 'full',
		nColor = 8,
		nShape = 8,
		nFill = 2,
		nLevels = 8
		}
	table.insert(modi,modus)
	table.insert(modi,customMode)	
				
end

function modeselect.goto()
	modeselect.init()
	cursor = {}
	cursor.shape = love.math.random(#outline)
	cursor.color = love.math.random(#color)
	cursor.fill = love.math.random(2)
	state = 'modeselect'
end

function modeselect.draw()
	love.graphics.setFont(largeFont)
	love.graphics.setColor(200,200,200)
	love.graphics.printf('Select mode',0,20,500,'center')
	for k,v in ipairs(modi) do
		love.graphics.printf(v.name,200,k*50+50,350,'left')
	end
	drawShape(140,selection*50+20+60, cursor.color,cursor.shape,cursor.fill,0.5)
	
	-- Box
	love.graphics.setColor(35,35,45)
	love.graphics.rectangle('fill',0,380,500,140)
	
	-- Descriptions
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(smallFont)
	love.graphics.printf('Levels',0,390,165,'right')
	love.graphics.printf(modi[selection].nLevels,200,390,200,'left')	
	love.graphics.printf('Colors',0,420,165,'right')
	love.graphics.printf('Shapes',0,450,165,'right')
	love.graphics.printf('Styles',0,480,165,'right')
	
	love.graphics.setLineWidth(2)
	for i=1,#color do
		love.graphics.rectangle('line',200+(i-1)*27,420,23,23)
	end
	for i=1,#outline do
		love.graphics.rectangle('line',200+(i-1)*27,450,23,23)
	end
	for i=1,2 do
		love.graphics.rectangle('line',200+(i-1)*27,480,23,23)
	end
	
	for i=1,modi[selection].nColor do
		love.graphics.rectangle('fill',200+(i-1)*27,420,23,23)
	end
	for i=1,modi[selection].nShape do
		love.graphics.rectangle('fill',200+(i-1)*27,450,23,23)
	end
	for i=1,modi[selection].nFill do
		love.graphics.rectangle('fill',200+(i-1)*27,480,23,23)
	end

end

function modeselect.update(dt)
end

function modeselect.keypressed(key)
	local nOptions = #modi
	if key == 'down' then
		selection = (selection%nOptions)+1
		playSound('move')
	elseif key == 'up' then
		selection = ((selection-2)%nOptions)+1
		playSound('move')
	elseif key == 'escape' then
		states.menu.goto()
	elseif key == 'return' or key == ' ' then
		playSound('select')
		local thisMode = modi[selection]
		if thisMode.name == 'custom' then
			states.custom.goto()
			return
		else
			stages = newOrder(thisMode.nColor, thisMode.nShape, thisMode.nFill, thisMode.nLevels)
			newGame()
		end
	end
end

return modeselect
