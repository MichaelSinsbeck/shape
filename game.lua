local game = {}

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
		local soundId = love.math.random(#sound_check)
		sound_check[soundId]:rewind()
		sound_check[soundId]:play()
	else
		sound_error:rewind()
		sound_error:play()
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
		local nCol = 3

		x = 200-(count[dir] % nCol)*55
		y = math.floor(count[dir]/nCol)*55+75
		if dir == 2 then x = 500 - x end
		
		count[dir] = count[dir] + 1			
		
		drawShape(x,y,v.color,v.shape,v.fill,0.5)
	end
end

function game.draw()
	if love.keyboard.isDown('tab') then -- if tab is held: show order
		game.drawOrder()
	else
		love.graphics.setColor(200,200,200)
		love.graphics.setFont(largeFont)
		love.graphics.printf(score,0,50,250,'right')
		
		local height = timerToScore(timer)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line',50,120,200,30)
		love.graphics.rectangle('fill',250-2*height,120,2*height,30)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(155,155,155)
		love.graphics.printf(height,150,124,98,'right')
		love.graphics.setFont(tinyFont)
		love.graphics.setColor(200,200,200)
		love.graphics.printf('Press "tab" to see ordering',50,156,200,'left')
		
		love.graphics.setColor(35,35,45)
		love.graphics.rectangle('fill',180,380,140,140)
		for i = #thisLevel,1,-1 do
				v = thisLevel[i]
				local factor = 2
				local z = (i+offset-1)/factor + 1
				local y = 20 + 430/z
				local x = 400 - math.exp(-(z-1)) * 150
				drawShape(x,y,v.color,v.shape,v.fill,1/z)
		end
	end
	
end

return game
