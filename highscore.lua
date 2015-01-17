local highscore = {}

function highscore.goto()
	state = 'highscore'
end

function highscore.draw()
	-- shapes from before
	states.game.drawOrder()
	-- box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',xleft,380,xwidth,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(xleft,380,xwidth,380)	
	
	-- what key to press
	love.graphics.setColor(colorFG)
	love.graphics.setFont(smallFont)
	myPrint('press "return"',0,352,500,'center')

	love.graphics.setFont(largeFont)	
	myPrint('game over',0,390,500,'center')

	love.graphics.setColor(colorEmph)
	myPrint(score,0,450,500,'center')


end

function highscore.update(dt)
end

function highscore.keypressed(key)
	if key == 'return' or key == 'escape' then
		states.unlock.goto()
	end
end

return highscore
