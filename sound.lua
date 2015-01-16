local sounds = {}

local function addSound(name,filename)
	filename = 'sound/' .. filename
	sounds[name] = sounds[name] or {}
	local newSource = love.audio.newSource(filename,'static')
	table.insert(sounds[name],newSource)
end

function loadSounds()
	addSound('check','Blop-Mark_DiAngelo-79054334.wav')	
	addSound('select','button-20.wav')
	addSound('error','beep-10.wav')
	addSound('tada','Ta Da-SoundBible.com-1884170640.wav')
	addSound('goat','Bleat-SoundBible.com-893851569.wav')
	addSound('move','Tick-DeepFrozenApps-397275646.mp3')
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
