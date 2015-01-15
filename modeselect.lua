local modeselect = {}
local selection = 1
local cursor

customMode = {
		name = 'custom',
		nColor = 1,
		nShape = 1,
		nFill = 1,
		nLevels = 1,
		threshold = 50000
		}

function modeselect.init()
	modi = {}
	local modus
	modus = {
		name = 'easy',
		nColor = 8,
		nShape = 8,
		nFill = 2,
		nLevels = 6,
		threshold = 0
		}
	table.insert(modi,modus)	
	modus = {
		name = 'color',
		nColor = 8,
		nShape = 1,
		nFill = 1,
		nLevels = 8,
		threshold = 10000
		}
	table.insert(modi,modus)
	
	modus = {
		name = 'shape',
		nColor = 1,
		nShape = 8,
		nFill = 1,
		nLevels = 8,
		threshold = 30000
		}
	table.insert(modi,modus)
	modus = {
		name = 'brainfuck',
		nColor = 2,
		nShape = 2,
		nFill = 2,
		nLevels = 8,
		threshold = 40000
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
	-- Title line
	love.graphics.setFont(largeFont)
	love.graphics.setColor(colorEmph)
	love.graphics.printf('Select mode',0,20,500,'center')
	-- Mode names
--	love.graphics.setColor(colorFG)
	for k,v in ipairs(modi) do
		if k <= lock then
			love.graphics.setColor(colorFG)
			love.graphics.printf(v.name,200,k*50+50,350,'left')
		else
			love.graphics.setColor(colorBox)
			love.graphics.printf(v.name,200,k*50+50,350,'left')
			love.graphics.setColor(colorFG)			
			love.graphics.rectangle('fill',174,k*50+80,16,14)
			love.graphics.setLineWidth(2)
			love.graphics.circle('line',182,k*50+80,6,20)			
		end
	end
	drawShape(140,selection*50+23+60, cursor.color,cursor.shape,cursor.fill,0.4)
	
	-- Locks
--[[	love.graphics.setColor(colorFG)
	for i=lock+1,#modi do
		local width = 8
		love.graphics.rectangle('fill',174,i*50+80,16,14)
		love.graphics.setLineWidth(2)
		love.graphics.circle('line',182,i*50+80,6,20)
--182,selection*30+360+12, cursor.color,cursor.shape,cursor.fill,0.2)		
	end--]]
	
	-- Box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',0,380,500,140)
	
	
	-- Descriptions
	love.graphics.setColor(colorFG)
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
	
	if selection > lock then -- if not unlocked yet, display condition
		love.graphics.setColor(colorBox[1],colorBox[2],colorBox[3],210)
		love.graphics.rectangle('fill',0,380,500,140)
		local thresh = modi[selection].threshold
		local prev = modi[selection-1].name
		love.graphics.setColor(colorEmph)
		love.graphics.setFont(smallFont)
		love.graphics.printf('Win ' .. thresh .. ' point in mode "' .. prev .. '" to unlock',0,435,500,'center')
	end
	
	-- box border
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(0,380,500,380)	

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
	elseif (key == 'return' or key == ' ') and selection <= lock then
		playSound('select')
		local thisMode = modi[selection]
		if thisMode.name == 'custom' then
			states.custom.goto()
			return
		else
			stages = newOrder(thisMode.nColor, thisMode.nShape, thisMode.nFill, thisMode.nLevels, thisMode.name)
			newGame()
		end
	end
end

return modeselect
