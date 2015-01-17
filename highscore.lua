local highscore = {}
local list
local maxListLength = 10
local idxNew
local timer = 0
local filename
local replacementNames =
	{'prefers to be anonymous','too lazy to type','John Doe','1337h4x0r'}

function highscore.goto()
	state = 'highscore'
	
	-- load highscore table from file if exists
	if stages.name ~= 'custom' then
		filename = stages.name .. '.txt'
		list = loadScoreList(filename)		

		-- check, if player is in highscore
		if #list < maxListLength or score > list[#list].score then
			isInList = true
			local newEntry = {name = '', score = score}
			table.insert(list,newEntry)
			table.sort(list, function(a,b) return a.score > b.score end)
			-- cut off lower part of the table
			for i=maxListLength+1,#list do
				list[i] = nil
			end
			-- find index of new entry
			for i=1,#list do
				if list[i] == newEntry then
					idxNew = i
				end
			end
		else
			idxNew = nil
		end
	
	  -- enable text input
	end	
end

function loadScoreList(filename)
	local thisList = {}
	local countType = 0
	local count = 1
	if love.filesystem.exists(filename) then
		for line in love.filesystem.lines(filename) do
			countType = countType + 1
			if countType%2 == 1 then
				thisList[count] = {name = line}
			else
				thisList[count].score = tonumber(line)
				count = count + 1
			end
		end
	end
	return thisList
end

function saveScoreList(filename,list)
	local output = ''
	for k,v in ipairs(list) do
		if k> 1 then output = output .. '\n' end
		output = output .. v.name ..'\n' .. v.score
	end
	love.filesystem.write(filename,output)
end

function highscore.draw()
	
	if love.keyboard.isDown('tab') then
		-- shapes from before
		states.game.drawOrder()
	else
		-- title
		love.graphics.setColor(colorEmph)
		love.graphics.setFont(largeFont)
		myPrint('Game over',0,20,500,'center')
		-- show high score table
		love.graphics.setFont(smallFont)

		for k,v in ipairs(list) do
			local y = 25*k+75
			if k ~= idxNew then -- all old entries
				love.graphics.setColor(colorFG)		
				myPrint(v.score,0,y,165,'right')
				myPrint(v.name,200,y,400,'left')
			else -- the new entry
				local extra = ''
				if timer % 0.5 < 0.25 then
					extra = '_'
				end
				love.graphics.setColor(colorEmph)
				myPrint(v.score,0,y,165,'right')
				myPrint(v.name .. extra,200,y,400,'left')
			end
		end
		love.graphics.setColor(colorBox)
		for i = #list+1,maxListLength do
			local y = 25*i+75		
			myPrint(0,0,y,165,'right')
			myPrint('- empty -',200,y,400,'left')		
		end
	end
	
	
	-- box
	love.graphics.setColor(colorBox)
	love.graphics.rectangle('fill',xleft,380,xwidth,140)
	love.graphics.setColor(colorFG)
	love.graphics.setLineWidth(2)
	love.graphics.line(xleft,380,xwidth,380)	
	
	-- what key to press
	--love.graphics.setColor(colorFG)
	--love.graphics.setFont(smallFont)
	--myPrint('press "return"',0,352,500,'center')

	love.graphics.setFont(smallFont)
	myPrint('score:',0,390,500,'center')

	love.graphics.setFont(largeFont)
	love.graphics.setColor(colorEmph)
	myPrint(score,0,450,500,'center')


end

function highscore.textinput(text)
	if idxNew and string.len(list[idxNew].name) < 30 then
		list[idxNew].name = list[idxNew].name .. text
--		print(list[idxNew].name)		
	end
end

function highscore.update(dt)
	timer = timer + dt
end

function deleteLastCharacter(s)
    return string.gsub(s, "[^\128-\191][\128-\191]*$", "")
end

function highscore.keypressed(key)
	if idxNew and key == 'backspace' then
		list[idxNew].name = deleteLastCharacter(list[idxNew].name)
--		print(list[idxNew].name)
	end
	if key == 'return' or key == 'escape' then
		if idxNew then
			if list[idxNew].name == '' then
				list[idxNew].name = replacementNames[love.math.random(#replacementNames)]
			end
			saveScoreList(filename,list)
			idxNew = nil
		else
			states.unlock.goto()
		end
	end
end

return highscore
