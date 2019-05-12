require("palettes")

function PaletteIdx()
	local o={
        img=nil,
        palIdx=1,
        totalCols=CONF.width/8,
        col = nil,
        row = nil,
		yoffset = 64 * CONF.cameraZoom,
		palettes = Palettes(),
		font=love.graphics.newFont("assets/pico8.ttf", 12),
		debounce=true,
	}
		
	function o:keyreleased(key)
		if key == "left" then
			o.palIdx =  (o.palIdx - 1) % (#o.palettes.names+1)
		elseif key == "right" then
			o.palIdx = (o.palIdx + 1) % (#o.palettes.names+1)
		end
		if o.palIdx == 0 then o.palIdx = 1 end
	end

	function o:mouseover()
        local mx,my = love.mouse.getPosition()
        if mx >= 0 and mx  <= o.yoffset
        and my >= 0 and my <= o.yoffset then
            return true
        end

        return false
	end
	
	function o:update(dt)
		if love.mouse.isDown(1) then
			if o.debounce and o:mouseover() then
				o.debounce = false
				o.palIdx = (o.palIdx + 1) % (#o.palettes.names+1)
				if o.palIdx == 0 then o.palIdx = 1 end
			end
		else
			o.debounce = true
        end
	end

	function o:draw(dt)
		local pal = o.palettes[o.palettes.names[o.palIdx]]
		local xx = 0
		local yy = 0
		local ww = ((CONF.width/8)*CONF.cameraZoom)

		local f = love.graphics.getFont()
		love.graphics.setFont(o.font)
		for i=1, #pal do
			love.graphics.setColor(pal[i])
			love.graphics.rectangle("fill", xx, yy, ww, ww)

			love.graphics.setColor(0.5,1,1,1)
			love.graphics.printf(i, xx, yy+25, ww, "center")

			xx = xx + ww
			if (i % 4) == 0 then
				xx = 0
				yy = yy + ww
			end
		end
		love.graphics.setFont(f)
	end

	return o
end