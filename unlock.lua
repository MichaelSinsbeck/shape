local unlock = {}
local message

function unlock.goto()
	message = nil
	if stages.name == modi[lock].name and modi[lock+1] and score >= modi[lock+1].threshold then
		lock = lock + 1
		message = modi[lock].name
		saveState()		
	end

	if message then
		state = 'unlock'
	else
		states.modeselect.goto()
	end
end

function unlock.draw()
	love.graphics.setFont(largeFont)

	love.graphics.setColor(colorEmph)
	love.graphics.printf('New mode unlocked',0,20,500,'center')
	
	love.graphics.setColor(colorFG)
	love.graphics.printf(message,0,250,500,'center')
end

function unlock.update(dt)
end

function unlock.keypressed(key)
	if key == 'return' or key == 'escape' then
		states.modeselect.goto()
	end
end

return unlock
