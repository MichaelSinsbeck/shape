local highscore = {}

function highscore.goto()
	state = 'highscore'
end

function highscore.draw()
	-- shapes from before
	states.game.drawOrder()
	-- box
	love.graphics.setColor(35,35,45)
	love.graphics.rectangle('fill',0,380,500,140)
	
	-- what key to press
	love.graphics.setColor(200,200,200)
	love.graphics.setFont(smallFont)
	love.graphics.printf('press "return"',0,355,500,'center')

	love.graphics.setFont(largeFont)	
	love.graphics.printf('game over',0,390,500,'center')
	love.graphics.setFont(largeFont)
	love.graphics.printf('score:',50,450,400,'left')
	love.graphics.printf(score,50,450,400,'right')
	love.graphics.setFont(smallFont)
	--love.graphics.printf('Press "return" to start a new game',0,450,500,'center')

end

function highscore.update(dt)
end

function highscore.keypressed(key)
	if key == 'return' or key == 'escape' then
		states.modeselect.goto()
	end
end

return highscore
