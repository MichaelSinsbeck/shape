local game = {}
local aboutToQuit
local swipes = {}
local levelOver = false
local endTimer = 0
local comboPoint
local maxPt = 0
local flyingScores = {}

function game.goto()
	state = 'game'
	offset = 0
	timer = 0
	swipes = {}
	aboutToQuit = false
	levelOver = false
	endTimer = 0
	if level == 1 then
		comboPoint = 0
	end
end

function timerToScore(timer)
	-- linear score
	--local thisScore = math.floor(math.min(math.max(0,1.2-timer),1) * 100)
	-- exponential decay
	local thisScore = math.floor(comboPoint * math.min(math.exp(-timer+0.2),1))
	return thisScore
end

function addFlyingScore(score)
	if score > 0 then
		local newScore = {score='+ ' .. score,timer = 0}
		table.insert(flyingScores,newScore)
	end
end

function registerKey(key)
	started = true
	if thisLevel[1].direction == key then -- correct key
		local scoreToAdd = timerToScore(timer)
		score = score + scoreToAdd
		addFlyingScore(scoreToAdd)
		
		local pitch = 2^(comboPoint/300) * 0.75
		playSound('check',pitch)
		
		-- Was originally used for the marimba sound
		--local logpitch = comboPoint/160
		--local octave = math.min(math.floor(logpitch),4)
		--local soundName = 'c' .. (octave+2)
		--local pitch = 2^(logpitch-octave)
		--print ('octave: ' .. octave )		
		--playSound(soundName,pitch)
		
		comboPoint = scoreToAdd + 10
		maxPt = math.max(maxPt,comboPoint)

		
		local thisShape = table.remove(thisLevel,1)
		local xTarget
		if key == 1 then xTarget = xleft-50 else xTarget = xwidth+50 end
		table.insert(swipes,{shape = thisShape,x=250,xTarget=xTarget})
	else -- wrong key
		if comboPoint > 400 then
			playSound('goat')
		else
			playSound('error')
		end
		comboPoint = 0
		table.remove(thisLevel,1)	
	end
	if #thisLevel == 0 then
		levelOver = true
		started = false
	end
	timer = 0
	offset = 1
end

function game.keypressed(key)
	if levelOver then return end
	if key == 'escape' then
		if not aboutToQuit then
			aboutToQuit = true
		else
			states.modeselect.goto()
			playSound('back')
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
	local speed = 2500
	for k,v in ipairs(swipes) do -- move swipes
		local dx = v.x-v.xTarget
		if math.abs(dx) < speed*dt then
			v.dead = true
		elseif dx > 0 then
			v.x = v.x - speed*dt
		else
			v.x = v.x + speed*dt
		end
	end
	for i=#swipes,1,-1 do -- remove dead swipes
		if swipes[i].dead then
			table.remove(swipes,i)
		end
	end
	for k,v in ipairs(flyingScores) do
		v.timer = v.timer + dt
	end
	-- remove dead flying scores
	for i=#flyingScores,1,-1 do
		if flyingScores[i].timer > 0.3 then
			table.remove(flyingScores,i)
		end
	end
	if started then
		timer = timer + dt
	end
	if levelOver then
	endTimer = endTimer + dt
		if endTimer > 0.5 then
			states.explanation.goto()
		end
	end	
end

function game.drawOrder()
	love.graphics.setFont(smallFont)
	love.graphics.setColor(colorFG)
	myPrint('left',0,10,225,'right')
	myPrint('right',275,10,200,'left')
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
		love.graphics.setColor(colorBox)
		love.graphics.rectangle('fill',-5,-5,265,185)
		love.graphics.setColor(colorFG)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line',-5,-5,265,185)				
		-- total score
		love.graphics.setColor(colorFG)
		love.graphics.setFont(largeFont)
		myPrint(score,0,20,230,'right')
		
		-- new score
		local height = math.min(timerToScore(timer),600)
		love.graphics.setLineWidth(2)
		love.graphics.rectangle('line',30,110,200,30)
		love.graphics.rectangle('fill',230-height/3,110,height/3,30)
		love.graphics.setFont(smallFont)
		love.graphics.setColor(colorEmph)
		myPrint(timerToScore(timer),33,114,194,'right')
		-- flying scores
		for k,v in ipairs(flyingScores) do
			local y = 74+40*math.exp(-v.timer*10)
			love.graphics.setColor(colorEmph)
			myPrint(v.score,33,y,194,'right')
		end		
		-- press tab
		love.graphics.setFont(tinyFont)
		love.graphics.setColor(colorFG)
		myPrint('Hold "tab" to see ordering',30,146,200,'left')
		
		-- press escape again to quit
		if aboutToQuit then
			love.graphics.setFont(tinyFont)
		myPrint('Press "esc" again to quit',2,2,498,'left')
		end
		
		-- box around current shape
		love.graphics.setColor(colorBox)
		love.graphics.rectangle('fill',xleft,380,xwidth,140)
		love.graphics.setColor(colorFG)
		love.graphics.setLineWidth(2)
		love.graphics.line(xleft,380,xleft+xwidth,380)			
		-- all the shapes
		for i = math.min(#thisLevel,40),1,-1 do
				v = thisLevel[i]
				local factor = 2
				local z = (i+offset-1)/factor + 1
				local y = 20 + 430/z
				local x = 400 - math.exp(-(z-1)) * 150
				local fade = 1
				if i>1 then fade = math.exp(0.15*(1-i)) end
				drawShape(x,y,v.color,v.shape,v.fill,1/z,fade)
		end

		-- swiping shape
		for k,v in ipairs(swipes) do
			drawShape(v.x,450,v.shape.color,v.shape.shape,v.shape.fill)
		end
	end
	
end

return game
