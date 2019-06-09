function love.conf(t)
    CONF = {}
    CONF.gameTitle  = "Jam Hammer"
    CONF.version = 0.1
    CONF.width   = 256
    CONF.height  = 320
    CONF.cameraZoom = 3

    -- terminal command to open it and execute commands on it
    CONF.terminal = 'gnome-terminal -- bash -c'

    -- webserver command to execute
    CONF.webServer = '~/.nvm/versions/node/v9.3.0/bin/http-server'



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
