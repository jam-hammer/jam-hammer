function love.conf(t)
    CONF = {}
    CONF.gameTitle  = "Jam Hammer"
    CONF.version = 0.1
    CONF.width   = 128
    CONF.height  = 192
    CONF.cameraZoom = 4

    --[[ Proceed with caution below this line ]]--
    CONF.windowWidth  = (CONF.width * CONF.cameraZoom)
    CONF.windowHeight = (CONF.height* CONF.cameraZoom)
    t.title = CONF.gameTitle -- Window title
    t.window.width = CONF.windowWidth
    t.window.height = CONF.windowHeight
    t.window.resizable = false
    t.window.fullscreen = false
    t.version = "0.10.0"
end
