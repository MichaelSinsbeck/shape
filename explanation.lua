local explanation = {}
local button
function explanation.goto()
	level = level + 1
	if level > #stages then
		states.highscore.goto()
		return
	end
	thisLevel = generateLevel(stages,level,level*10)
	state = 'explanation'
	started = false
end

function explanation.draw()
	if level > 1 then
		states.game.drawOrder()
	end

	local v = stages[level]
	if v.direction == 1 then
		button = 'left'
	else
		button = 'right'
	end
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(largeFont)
	love.graphics.printf('New shape goes ' .. button,0,250,500,'center')
	
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "' .. button ..'" to continue',0,550,500,'center')
	
	love.graphics.setColor(35,35,45)
	love.graphics.rectangle('fill',0,380,500,140)
	

	drawShape(250,450,v.color,v.shape,v.fill,1)

end

function explanation.update(dt)
end

function explanation.keypressed(key)
	if key == button then
		state = 'game'
		offset = 0
		timer = 0
		playSound('check')
	end
end

return explanation
