local composer = require( "composer" )
local clockA = require("objects.aclock")
local clockD = require("objects.dclock")
local physics = require("physics")
local widget = require("widget")

physics.start()
--physics.setDrawMode("hybrid")

local scene = composer.newScene()

local askY = centerY
local askX = _W*.75
local aW = _W*.25
local dW = _W*.75
local timeString
local digital
local analog
local text
local answerText = display.newText("", _W*.45, _H * .80, font, _W*.075)
                answerText:setFillColor( 0, 0, 0 )

local function reset()
    answerText.text = ""
    answerText:setFillColor( 0, 0, 0 )
    timeString = string.format( "%04d",  tostring( math.random( 1, 12 )*5   + math.random( 1, 12 ) * 100 ) )
    analog.setTime( timeString)
    digital.setTime("0000")
     text.text = "What Time Is It?"
end

local function check()
    print("CHECKED")
    print( timeString == digital.getTime() )
    if ( timeString == digital.getTime() ) then
        answerText.text = "Correct!"
        text.text = ""
        answerText:setFillColor( Green.R, Green.G, Green.B )
        timer.performWithDelay( 1500, reset )
    else 
        answerText.text = "Try Again!"
        answerText:setFillColor( Red.R, Red.G, Red.B )
    end

end

function scene:create( event )

	local sceneGroup = self.view
    local background = display.newImageRect( sceneGroup,"images/bg_blue_zig.png",
            display.contentWidth, display.contentHeight )
    background.x, background.y = centerX, centerY
    timeString = string.format( "%04d",  tostring( math.random( 1, 12 )*5   + math.random( 1, 12 ) * 100 ) )
    print("Random Time: "..timeString)
	digital = dClock:new(dW, askY, true, 0, 0)
    analog = aClock:new(aW, askY, 0, false)
    analog.setTime( timeString  )
    sceneGroup:insert( analog )
    sceneGroup:insert( digital )


    text = display.newText("What Time Is It?", centerX, _H*.25, font, fontSize)
    text:setFillColor(0,0,0)
     sceneGroup:insert( text )


    local checkPad = display.newCircle( analog.x, analog.y, 160 )
    checkPad:setFillColor(0,0,0,.01)
    sceneGroup:insert( checkPad )


	sceneGroup:insert(analog)
    sceneGroup:insert(text)


    local menu = display.newImageRect( "images/menu.png",
            _H*.1,  _H*.1)
    menu.x, menu.y = _W*.9, _H*.1
    local function listener()
        composer.gotoScene( "menu" )
    end
    menu:addEventListener( "tap", listener )
    sceneGroup:insert( menu )

    local play = display.newImageRect( "images/change_page.png",
            _H*.1,  _H*.1)
    play.x, play.y = _W*.1, _H*.9
    play.rotation = 180
    local function listener()
        composer.gotoScene( "lessons.lesson11_playground" )
    end
    play:addEventListener( "tap", listener )
    sceneGroup:insert( play )

    local checkButton = widget.newButton{
                    id = "CheckButton",
                    width = _W*.05,
                    height = _W*.05,
                    defaultFile="images/check.png",
                    overFile="images/check.png", -- not needed
                    onPress = check,
    }
    checkButton.x, checkButton.y = askX, askY + _H*.25
    sceneGroup:insert( checkButton )
    
end

function scene:show( event )

    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end

function scene:hide( event )
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end

function scene:destroy( event )
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
