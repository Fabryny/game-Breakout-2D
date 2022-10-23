
require 'src/Dependencies'

function love.load()
    love.graphics.setDefaultFilter('nearest','nearest')

    math.randomseed(os.time())    -- seed the RNG so that calls to random are always random

    love.window.setTitle('Breakout')

    love.graphics.setFont(gFonts['small'])

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {   
      vsync = true,
      fullscreen = false,
      resizable = true
    })
        
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
    }
    gStateMachine:change('start')
    love.keyboard.keysPressed = {}

end

function love.resize(w,h)
    push:resize(w,h)
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.draw()
    push:apply('start')
    
    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], 
    -- draw at coordinates 0, 0
    0, 0, 
    -- no rotation
    0,
    -- scale factors on X and Y axis so it fills the screen
    VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    displayFPS()

    push:apply('end')
end

function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end