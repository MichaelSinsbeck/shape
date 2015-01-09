states = {}
states.game = require('game')
states.explanation = require('explanation')
states.highscore = require('highscore')
require('shape')

function newGame()
	started = false
	timer = 0
	score = 0
	level = 0

	stages = newOrder(2,2,2)
	thisLevel = generateLevel(stages,level,level*10)
	states.explanation.goto()
end

function love.load()


	offset = 0
	love.graphics.setBackgroundColor(25,25,35)
	initShapes()
	
	largeFont = love.graphics.newFont(50)
	smallFont = love.graphics.newFont(20)
	tinyFont = love.graphics.newFont(10)
	love.graphics.setFont(largeFont)
	
	newGame()
	
--	sound_check = love.audio.newSource('check.wav','static')
	sound_check = {}
	table.insert(sound_check,love.audio.newSource('Woosh-Mark_DiAngelo-4778593.wav','static')	)
	--table.insert(sound_check,love.audio.newSource('Blop-Mark_DiAngelo-79054334.wav','static'))
	--table.insert(sound_check,love.audio.newSource('whip-whoosh-03.wav','static'))
	sound_error = love.audio.newSource('beep-10.wav','static')	
end


function love.draw()
	if states[state] then
		states[state].draw()
	end
end

function love.update(dt)
	if states[state] then
		states[state].update(dt)
	end
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	end
	if states[state] then
		states[state].keypressed(key)
	end	

end
