require 'src/Dependencies'

--[[
	Called only once at the beginning of the application
]]

function love.load()
	--set love2D's default filter to "nearest"
	love.graphics.setDefaultFilter('nearest','nearest')

	--seed the random number generator
	math.randomseed(os.time())

	-- set the application title bar
    	love.window.setTitle('Dolch Sight Words')

	-- initialize the 'PoorStoryFont'
    	gFonts = {
        	['small'] = love.graphics.newFont('fonts/PoorStoryFont.ttf', 8),
        	['medium'] = love.graphics.newFont('fonts/PoorStoryFont.ttf', 16),
        	['large'] = love.graphics.newFont('fonts/PoorStoryFont.ttf', 32)
    	}
	
	love.graphics.setFont(gFonts['small'])

	--load up the graphics used in the application
	gGraphics = {
		['microphone'] = love.graphics.newImage('graphics/microphone.png'),
		['nextIcon'] = love.graphics.newImage('graphics/doubleArrowsRight.png'),
		['statsIcon'] = love.graphics.newImage('graphics/notebook.png')
	}

	-- initialize virtual resolution
    	push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        	vsync = true,
        	fullscreen = false,
        	resizable = true
   	})

	--set up sound effects
	--adding all similar sound effects right now. Needs to be updated later
	gSounds = {
		['correct'] = love.audio.newSource('sounds/select.wav','static'),
		['incorrect'] = love.audio.newSource('sounds/select.wav','static'),
		['listen'] = love.audio.newSource('sounds/select.wav','static'),
		['stats'] = love.audio.newSource('sounds/select.wav','static'),
		['return'] = love.audio.newSource('sounds/select.wav','static'),
		['close'] = love.audio.newSource('sounds/select.wav','static')
	}

	--state machines used in the application
	--1. 'display' (the word to be read is displayed on the screen)
	--2. 'listen' (the microphone listens to the user and checks if the user has pronounced the word correctly)
	--3. 'feedback' (the user is given feedback on whether he/she pronounced the word correctly)
	--4. 'score' (the user's score statistic is displayed)
	gStateMachine = StateMachine {
		['start'] = function() return StartState() end,
		['display'] = function() return DisplayState() end,
		['listen'] = function() return ListenState() end,
		['help'] = function() return HelpState() end,
		['feedback'] = function() return FeedbackState() end,
		['score'] = function() return ScoreState() end
	}
	gStateMachine:change('start')

	--a table to keep track of all the keypresses within the frame
	love.keyboard.keysPressed = {}
end


--[[
	Called when the dimensions of the window is changed
--]]
function love.resize(w, h)
    push:resize(w, h)
end


--[[
	Called every frame (dt is the time interval between two frames)
--]]
function love.update(dt)
    -- pass dt to the StateMachine currently in use
    gStateMachine:update(dt)

    -- reset keys pressed
    love.keyboard.keysPressed = {}
end


-- a callback function to record the keypresses
function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
end


--[[
    A custom function that tests which key was pressed
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end


--[[
    Called each frame to draw on the screen
]]
function love.draw()
    -- begin drawing with push, in our virtual resolution
    push:apply('start')
    
    -- use the state machine to defer rendering to the current state we're in
    gStateMachine:render()
    
    -- display FPS for debugging; simply comment out to remove
    displayFPS()
    
    push:apply('end')
end

--[[
    Renders the current FPS.
]]
function displayFPS()
    -- simple FPS display across all states
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
