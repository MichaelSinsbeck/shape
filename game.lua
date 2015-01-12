local game = {}
local aboutToQuit

function game.goto()
	state = 'game'
	offset = 0
	timer = 0
	aboutToQuit = false
end

function timerToScore(timer)
	-- linear score
	--local thisScore = math.floor(math.min(math.max(0,1.2-timer),1) * 100)
	-- exponential decay
	local thisScore = math.floor(100 * math.min(math.exp(-timer+0.2),1))
	return thisScore
end

function registerKey(key)
	started = true
	if thisLevel[1].direction == key then
		score = score + timerToScore(timer)
		playSound('check')
	else
		playSound('error')
	end
	table.remove(thisLevel,1)
	if #thisLevel == 0 then
		states.explanation.goto()
		return
	end
	timer = 0
	offset = 1
end

function game.keypressed(key)
	if key == 'escape' then
		if not aboutToQuit then
			aboutToQuit = true
		else
			states.modeselect.goto()
		end
	else
		aboutToQuit = false
	end
	if key == 'left' then
		registerKey(1)
	elseif key == 'right' then
		registerKey(2)
	end
end

function game.update(dt)
	offset = math.max(offset - 10*dt,0)
	if started then
		timer = timer + dt
	end
end

function game.drawOrder()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(200,200,200)
	love.graphics.printf('left',0,10,225,'right')
	love.graphics.printf('right',275,10,200,'left')
	local count = {0,0}
	for i=1,level do
		local v = stages[i]
		local dir = v.direction
		local x
		local y
		local nCol = 2

		x = 180-(count[dir] % nCol)*80
		y = math.floor(count[dir]/nCol)*80+75
		if dir == 2 then x = 500 - x end
		
		count[dir] = count[dir] + 1			
		
		drawShape(x,y,v.color,v.shape,v.fill,0.7)
	end
end

function game.draw()
	-- if tab is held: show order
	if love.keyboard.isDown('tab') then
		game.drawOrder()
	else
		-- box around score
		love.graphics.setColor(35,35,45)
		love.graphics.rectangle('fill',0,0,260,140)
		-- total score
		love.graphics.setColor(200,200,200)
		love.graphics.setFont(largeFont)
		love.graphics.printf(score,0,20,230,'right')
		
		-- new score
		local height = timerToScore(timer)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line',30,80,200,30)
		love.graphics.rectangle('fill',230-2*height,80,2*height,30)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(155,155,155)
		love.graphics.printf(height,130,84,98,'right')
		-- press tab
		love.graphics.setFont(tinyFont)
		love.graphics.setColor(200,200,200)
		love.graphics.printf('Hold "tab" to see ordering',30,116,200,'left')
		-- press escape again to quit
		if aboutToQuit then
			love.graphics.setFont(tinyFont)
		love.graphics.printf('Press "esc" again to quit',2,2,498,'left')
		end
		
		-- box around current shape
		love.graphics.setColor(35,35,45)
		love.graphics.rectangle('fill',0,380,500,140)
		-- all the shapes
		for i = #thisLevel,1,-1 do
				v = thisLevel[i]
				local factor = 2
				local z = (i+offset-1)/factor + 1
				local y = 20 + 430/z
				local x = 400 - math.exp(-(z-1)) * 150
				local fade = 1
				if i>1 then fade = math.exp(0.15*(1-i)) end
				drawShape(x,y,v.color,v.shape,v.fill,1/z,fade)
		end
	end
	
end

return game
