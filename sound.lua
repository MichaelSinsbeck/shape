local sounds = {}

local function addSound(name,filename)
	sounds[name] = sounds[name] or {}
	local newSource = love.audio.newSource(filename,'static')
	table.insert(sounds[name],newSource)
end

function loadSounds()
--	addSound('check','Woosh-Mark_DiAngelo-4778593.wav')
	addSound('check','Blop-Mark_DiAngelo-79054334.wav')	
	--addSound('check','whip-whoosh-03.wav')
	addSound('move','Woosh-Mark_DiAngelo-4778593.wav')
	addSound('select','button-20.wav')
	addSound('error','beep-10.wav')

--[[	table.insert(sound_check,love.audio.newSource('Woosh-Mark_DiAngelo-4778593.wav','static')	)
	--table.insert(sound_check,love.audio.newSource('Blop-Mark_DiAngelo-79054334.wav','static'))
	--table.insert(sound_check,love.audio.newSource('whip-whoosh-03.wav','static'))
	sound_move = love.audio.newSource('Blop-Mark_DiAngelo-79054334.wav','static')
	sound_select = love.audio.newSource('button-21.wav','static')
	sound_error = love.audio.newSource('beep-10.wav','static')]]	
end

function playSound(name,pitch)
	local pitch = pitch or 1
	if soundOn and sounds[name] then
		local idx = love.math.random(#sounds[name])
		local thisSource = sounds[name][idx]
		thisSource:rewind()
		thisSource:setPitch(pitch)
		thisSource:play()
	end
end
