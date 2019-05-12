require('sheetidx')
require('paletteidx')
require('button')
require('toast')

local updateables={}
local drawables={}
local sheetIdx = SheetIdx()
local paletteIdx = PaletteIdx()
local projName = ""
local font = love.graphics.newFont("assets/pico8.ttf", 13)
local titleX = 66*CONF.cameraZoom
local winVerticalCenter = (CONF.height * CONF.cameraZoom)/2
local winWidth = CONF.width*CONF.cameraZoom

function createButtons()
	local yy = 45
	local height = 20
	local yOffset = 10
	local xOffset = titleX
	function lineFeed() yy = yy+height+yOffset end

	local exportLoveBtn = Button("Export love file", 
		function ()
			os.execute("mkdir -p build && zip -9 -r build/"..projName..".love . && echo done")
			local exportToast = Toast("Exported to build/ directory", 
				10,winVerticalCenter, 
				winWidth, 55, 
				200, function(obj) delEntity(obj) end)
			addEntity(exportToast)
		end,
		xOffset, yy, winWidth-xOffset, height) 
	lineFeed()

	local exportHtmlBtn = Button("Export HTML5", 
		function ()
			local wd = love.filesystem.getWorkingDirectory()
			local tmpDir = "/tmp/jamhammer/"..projName
			local lovejsDir = "../../love.js/release-compatibility"

			-- Copy the important files into a temp dir
			os.execute("mkdir -p "..tmpDir.." && rm -rf "..tmpDir.."/* && ls -1 | grep -v build | grep -v *.love | grep -v *.iml | xargs -i cp -r {} "..tmpDir)
			
			-- Package the game using love.js. The type is definded by the lovejsDir (debug, release-compatibility or release-performance)
			os.execute("cd "..lovejsDir.." && python ../emscripten/tools/file_packager.py game.data --preload "..tmpDir.."/@/ --js-output=game.js && echo done.")

			-- Debug type can't be moved from emscripten folder. Both release types can. This next line makes sense if it's a release build.
			os.execute("mkdir -p build && cp -r "..lovejsDir.." build/html5")
		end, 
		xOffset, yy, winWidth-xOffset, height) 
	lineFeed()

	
	addEntity(newProjBtn)
	addEntity(openProjBtn)
	addEntity(exportHtmlBtn)
	addEntity(exportLoveBtn)
end

function love.load(arg)
	love.graphics.setDefaultFilter("nearest", "nearest")
	love.graphics.setFont(love.graphics.newFont("assets/pico8.ttf", 60))
	love.mouse.setVisible(true)

	-- The project name is the folder where this is being executed.
	-- This is part of the JAM HAMMER conventions
	local workingDir = love.filesystem.getWorkingDirectory()
	for i in string.gmatch(workingDir, "([^/]+)") do projName = i end

	createButtons()

	addEntity(sheetIdx)
	addEntity(paletteIdx)
end

local sc=love.graphics.setColor
function love.graphics.setColor(r,g,b,a)
	if type(r) == 'table' then
		local t = r
		r = t[1]
		g = t[2]
		b = t[3]
		a = t[4]
	end

	sc(r*255, g*255, b*255, a*255)
end

function addEntity(ent)
	table.insert(updateables, ent)
	table.insert(drawables, ent)
end

function delEntity(ent)
	function getIndex(table, element)
		for index, value in pairs(table) do
			if value == element then
				return index
			end
		end
	end

	table.remove(updateables, getIndex(updateables, ent))
	table.remove(drawables, getIndex(drawables, ent))
end

function love.filedropped(file)
	sheetIdx:filedropped(file)
end

function love.keyreleased(key)
	paletteIdx:keyreleased(key)
end

function love.update(dt)
	table.foreach(updateables, function(k,u)
		u:update(dt)
	end)
end

function love.draw(dt)
	love.graphics.setColor(1, 1, 1, 1)

	local f = love.graphics.getFont()
	love.graphics.setFont(font)
	love.graphics.printf("Project:", titleX, CONF.cameraZoom,   CONF.width, "left")
	love.graphics.printf(projName,   titleX, 5*CONF.cameraZoom, CONF.width, "left")
	love.graphics.setFont(f)

	table.foreach(drawables, function(k,d)
		d:draw(dt)
	end)
end
