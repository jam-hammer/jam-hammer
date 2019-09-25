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

	function clearBuildDir()
		os.execute("rm -rf build/*")
	end

	function createLoveFile()
		local name = projName:gsub("%s+", "")
		clearBuildDir()
		os.execute("mkdir -p build && zip -9 -r build/"..name..".love . && echo done")
	end

	local exportLoveBtn = Button("Export love file", 
		function ()
			createLoveFile()
			showToast("Exported to build/ directory.")
		end,
		xOffset, yy, winWidth-xOffset, height) 
	lineFeed()

	local exportExeBtn = Button("Export .exe file",
		function ()
			local name = projName:gsub("%s+", "")
			local tmpDir = "/tmp/jamhammer-windows/"..name
			local love2dZipVersion = "love-0.10.0-win32"

			-- Create .love file first
			createLoveFile()

			-- Create/clean tmpDir
			os.execute("mkdir -p "..tmpDir.." && rm -rf "..tmpDir.."/*")

			-- Unzip love win32 dist into tmpDir
			os.execute("unzip ../../love/"..love2dZipVersion ..".zip -d "..tmpDir)

			-- Merge .love file into .exe
			local wd = love.filesystem.getWorkingDirectory()
			local loveFilePath = wd.."/build/"..name..".love"
			local tmpOutputPath = tmpDir.."/"..love2dZipVersion
			local outputPath = "build/"
			os.execute("cd ".. tmpOutputPath .." && cat love.exe "..loveFilePath.." > "..name..".exe")
			os.execute("cd ".. tmpOutputPath .." && rm love.exe changes.txt readme.txt ")

			print("mkdir -p "..outputPath.." && cd ".. tmpOutputPath .." && zip -9 -r "..outputPath..name..".zip  && echo done")
			os.execute("mkdir -p "..outputPath.." && cd ".. tmpOutputPath .." && zip -9 -r "..wd.."/"..outputPath..name.."-win32"..".zip . && echo done")

			showToast("Exported to "..outputPath.." directory.")
		end,
		xOffset, yy, winWidth-xOffset, height)
	lineFeed()

	local exportHtmlBtn = Button("Export HTML5", 
		function ()
			local name = projName:gsub("%s+", "")
			local tmpDir = "/tmp/jamhammer/"..name
			local lovejsDir = "../../love.js/release-compatibility"

			-- Copy the important files into a temp dir
			os.execute("mkdir -p "..tmpDir.." && rm -rf "..tmpDir.."/* && ls -1 | grep -v build | grep -v *.love | grep -v *.iml | xargs -i cp -r {} "..tmpDir)
			
			-- Package the game using love.js. The type is definded by the lovejsDir (debug, release-compatibility or release-performance)
			os.execute("cd "..lovejsDir.." && python ../emscripten/tools/file_packager.py game.data --preload "..tmpDir.."/@/ --js-output=game.js && echo done.")

			-- "Debug" type can't be moved from emscripten folder. Both "release" types can. This next line makes sense if it's a release build.
			os.execute("mkdir -p build && cp -r "..lovejsDir.." build/html5")

			showToast("Exported to build/html5/ directory.\nCheck debug build at "..tmpDir)
		end, 
		xOffset, yy, winWidth-xOffset, height) 
	lineFeed()

	local serveHtml = Button("Serve HTML5 export", 
		function ()
			local htmlDir = "build/html5/"

			os.execute(CONF.terminal..' "cd '..htmlDir..' && '..CONF.webServer..'"')
			showToast("Serving into localhost:8080.")
		end, 
		xOffset, yy, winWidth-xOffset, height) 
	lineFeed()

	addEntity(newProjBtn)
	addEntity(openProjBtn)
	addEntity(exportHtmlBtn)
	addEntity(exportLoveBtn)
	addEntity(serveHtml)
	addEntity(exportExeBtn)
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

function showToast(msg)
	local toast = Toast(msg, 10,winVerticalCenter, winWidth, 55, 200, function(obj) delEntity(obj) end)
	addEntity(toast)
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
	love.graphics.printf(projName,   titleX, 6*CONF.cameraZoom, CONF.width, "left")
	love.graphics.setFont(f)

	table.foreach(drawables, function(k,d)
		d:draw(dt)
	end)
end
