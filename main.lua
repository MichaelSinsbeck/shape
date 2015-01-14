states = {}
states.game = require('game')
states.explanation = require('explanation')
states.highscore = require('highscore')
states.menu = require('menu')
states.modeselect = require('modeselect')
states.custom = require('custom')
states.unlock = require('unlock')
require('shape')
require('sound')


function newGame()
	started = false
	timer = 0
	score = 0
	level = 0

	states.explanation.goto()
end

function love.load()
	-- initialize
	soundOn = true
	initShapes()
	loadSounds()
	
	-- define some colors
	colorBG = {15,15,25}
	colorBox = {45,45,55}
	colorFG = {180,180,180}
	colorEmph = {250,250,250}
	
	love.graphics.setBackgroundColor(colorBG)
	
	-- load fonts and logo
	logo = love.graphics.newImage('logo_small.png')
	largeFont = love.graphics.newFont('CaviarDreams.ttf',50)	
	smallFont = love.graphics.newFont('Caviar_Dreams_Bold.ttf',20)
	tinyFont = love.graphics.newFont('Caviar_Dreams_Bold.ttf',11)

	-- start game in menu
	states.menu.goto()
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
	--if key == 'escape' then
	--	love.event.quit()
	--end
	if states[state] then
		states[state].keypressed(key)
	end	

end
