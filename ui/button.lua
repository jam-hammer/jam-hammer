function Button(text,f,x,y,w,h)
    local o={
        text=text,
        x=x,
        y=y,
        w=w,
        h=h,
        font=love.graphics.newFont("assets/pico8.ttf", 12),
        debounce=true,
    }

    function o:mouseover()
        local mx,my = love.mouse.getPosition()
        if mx >= o.x and mx <= o.x+o.w 
        and my >= o.y and my <= o.y+o.h then
            return true
        end

        return false
    end

    function o:update(dt)
        if love.mouse.isDown(1) then
            if o:mouseover() and o.debounce then
                o.debounce = true
                f()
            end
            o.debounce = false
        else
            o.debounce = true
        end
    end

    function o:draw(dt)
        local f = love.graphics.getFont()
        love.graphics.setFont(o.font)

        -- background
        if o:mouseover() then love.graphics.setColor(0.1,0.1,0.5,1)
        else                  love.graphics.setColor(0.3,0.1,0.5,1)  end
        love.graphics.rectangle("fill", o.x, o.y, o.w-15, o.h)

        love.graphics.setColor(0.7,0.7,0.5,1)
        
        love.graphics.printf(o.text, o.x, o.y+5, o.w, "center")

        love.graphics.setFont(f)
    end

    return o
end