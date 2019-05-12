function SheetIdx ()
    local o={
        img=nil,
        idx=1,
        totalCols=CONF.width/8,
        col = nil,
        row = nil,
        yoffset = 64 * CONF.cameraZoom
    }
    
    function loadImage(imgPath)
        local w = assert(io.open(imgPath, "rb"))
        local file = love.filesystem.newFileData(w:read("*a"), "")
        o.img = love.graphics.newImage(file)
        w.close()
    end

    love.graphics.setDefaultFilter("nearest", "nearest")
    local path = love.filesystem.getWorkingDirectory().."/assets/sheet.png"
    pcall(loadImage, path) -- try to load the sheet.png from the current project

    function o:filedropped(file)
        loadImage(file:getFilename())
    end

    function o:update(dt)
        local x, y = love.mouse.getPosition()
        
        o.col = nil
        o.row = nil

        if y >= o.yoffset then
            love.mouse.setVisible(false)
            o.col = math.floor(x / (8*CONF.cameraZoom))
            o.row = math.floor((y-o.yoffset) / (8*CONF.cameraZoom))
            
            o.idx = ((o.totalCols*o.row)+o.col)+1
        else
            love.mouse.setVisible(true)
        end
    end

    function o:draw(dt)
        love.graphics.setColor(1, 1, 1, 1)
        if o.img == nil then
            love.graphics.printf("drag & drop sheet",0,(10*CONF.cameraZoom)+o.yoffset, CONF.width*CONF.cameraZoom, "center")
        else
            love.graphics.draw(o.img,0,o.yoffset,0,CONF.cameraZoom,CONF.cameraZoom)

            if self.col ~= nil then
                -- tile number:
                love.graphics.setColor(125, 255, 122, 200)
                love.graphics.printf(o.idx, 0,(CONF.height*CONF.cameraZoom)-58, CONF.width*CONF.cameraZoom, "center")
                -- tile number

                -- square "mouse cursor"
                local cz = CONF.cameraZoom*8
                local xx = o.col*cz
                local yy = (o.row*cz) + o.yoffset

                love.graphics.setColor(0, 0, 0, 255)
                love.graphics.rectangle("line", xx,yy, cz, cz)

                love.graphics.setColor(255, 255, 255, 255)
                love.graphics.rectangle("line", xx+1 , yy+1, cz-2, cz-2)

                love.graphics.setColor(255, 0, 30, 255)
                love.graphics.rectangle("line", xx+2 , yy+2, cz-4, cz-4)
            end
        end
    end

    return o
end