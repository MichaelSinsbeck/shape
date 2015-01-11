local modeselect = {}
local selection = 1
local modi
local textcolor = 1
local cursor

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
end

function modeselect.goto()
	modeselect.init()
	selection = 1
	cursor = {}
	cursor.shape = love.math.random(#outline)
	cursor.color = love.math.random(#color)
	cursor.fill = love.math.random(2)
	textcolor = love.math.random(#color)
	while textcolor == cursor.color do
		textcolor = love.math.random(#color)
	end
	state = 'modeselect'
end

function modeselect.draw()
	love.graphics.setFont(largeFont)
	love.graphics.setColor(200,200,200)
	love.graphics.printf('Select mode',0,40,500,'center')
	local r,g,b = color[textcolor][1],color[textcolor][2],color[textcolor][3]
	love.graphics.setColor(r,g,b)
	for k,v in ipairs(modi) do
		love.graphics.printf(v.name,200,k*60+60,350,'left')
	end
	drawShape(150,selection*60+30+60, cursor.color,cursor.shape,cursor.fill,0.5)
	
	-- Box
	love.graphics.setColor(35,35,45)
	love.graphics.rectangle('fill',0,380,500,140)
	
	-- Descriptions
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(smallFont)
	love.graphics.printf('Levels',0,390,170,'right')
	love.graphics.printf(modi[selection].nLevels,200,390,200,'left')	
	love.graphics.printf('Colors',0,420,170,'right')
	love.graphics.printf('Shapes',0,450,170,'right')
	love.graphics.printf('Styles',0,480,170,'right')
	
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
		--options[selection].fun()
		playSound('select')
	end
end

return modeselect
