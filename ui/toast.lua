function Toast(msg,x,y,w,h,duration,destroyfunc)
    local o={
        tick=0,
        font=love.graphics.newFont("assets/pico8.ttf", 20),
        w=CONF.width*CONF.cameraZoom
    }

    function o:update(dt)
        o.tick = o.tick +1
        if o.tick > duration then
            destroyfunc(self)
        end
    end

    function o:draw(dt)
        local of = love.graphics.getFont()
        love.graphics.setFont(o.font)
        love.graphics.setColor(0.3,0.1,0.5,1)
        love.graphics.rectangle("fill", x,y, w,h)

        love.graphics.setColor(1,1,1,1)
        love.graphics.printf(msg,x,y+4,w,"center")
        love.graphics.setFont(of)
    end

    return o
end