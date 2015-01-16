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
	--soundOn = true
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
	largeFont = love.graphics.newFont('font/CaviarDreams.ttf',50)	
	smallFont = love.graphics.newFont('font/Caviar_Dreams_Bold.ttf',20)
	tinyFont = love.graphics.newFont('font/Caviar_Dreams_Bold.ttf',11)
	
	-- load state
	loadFromFile()

	-- start game in menu
	states.menu.goto()
end

function loadFromFile()
	local filename = 'config.txt'
	if love.filesystem.exists(filename) then
		local content = {}
		for line in love.filesystem.lines(filename) do
			table.insert(content,line)
		end
		lock = tonumber(content[1])
		soundOn = (tonumber(content[2]) == 1)
		displayFlat = (tonumber(content[3]) == 1)
		customMode = {
				name = 'custom',
				nColor = tonumber(content[5]),
				nShape = tonumber(content[6]),
				nFill = tonumber(content[7]),
				nLevels = tonumber(content[4]),
				threshold = 50000,
				isRandom = (tonumber(content[8]) == 1)
				}		

		--print(lock)
		--print(soundOn)	
	else
		lock = 1
		soundOn = true
		displayFlat = true	

		customMode = {
				name = 'custom',
				nColor = 3,
				nShape = 5,
				nFill = 1,
				nLevels = 9,
				threshold = 50000,
				isRandom = true
				}
		-- create file:
		saveState()
	end
end

function saveState()
	local soundFlag
	local dispFlag
	local randomFlag
	if soundOn then
		soundFlag = 1
	else
		soundFlag = 0
	end
	if displayFlat then
		dispFlag = 1
	else
		dispFlag = 0
	end

	if customMode.isRandom then
		randomFlag = 1
	else
		randomFlag = 0
	end
	love.filesystem.append('config.txt', randomFlag)
	local output = lock ..'\n' .. soundFlag ..'\n' .. dispFlag ..'\n' .. customMode.nLevels ..'\n' .. customMode.nColor ..'\n' .. customMode.nShape ..'\n' .. customMode.nFill ..'\n' .. randomFlag	..'\n'
	
	love.filesystem.write('config.txt', output)	
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
	if states[state] then
		states[state].keypressed(key)
	end	

end
