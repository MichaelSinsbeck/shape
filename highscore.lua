local highscore = {}

function highscore.goto()
	state = 'highscore'
end

function highscore.draw()
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(smallFont)
	love.graphics.printf('Game over. Score:',0,200,500,'center')
	love.graphics.setFont(largeFont)
	love.graphics.printf(score,0,300,500,'center')
	love.graphics.setFont(smallFont)
	love.graphics.printf('Press "return" to start a new game',0,550,500,'center')
	
end

function highscore.update(dt)
end

function highscore.keypressed(key)
	if key == 'return' then
		newGame()
	end
end

return highscore
