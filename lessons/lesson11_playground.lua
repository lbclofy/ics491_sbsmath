local composer = require( "composer" )
local clockA = require("objects.aclock")
local clockD = require("objects.dclock")
local physics = require "physics"
physics.start()
--physics.setDrawMode("hybrid")

local scene = composer.newScene()

local playY = centerY
local aW = _W*.25
local dW = _W*.75


function scene:create( event )
	local sceneGroup = self.view
     local background = display.newImageRect( sceneGroup,"images/bg_blue_zig.png",
            display.contentWidth, display.contentHeight )
     background.x, background.y = centerX, centerY

	local analog = aClock:new(aW, playY, 0, true)
    sceneGroup:insert( analog )
	local digital = dClock:new(dW, playY, true, 0, 0)
    sceneGroup:insert( digital )    


    local checkPad = display.newCircle( analog.x, analog.y, 160 )
    checkPad:setFillColor(0,0,0,.01)
    sceneGroup:insert( checkPad )

    local checkPad2 = display.newRect( dW, playY, 600, 500 )
    checkPad2:setFillColor(0,0,0,.01)
    sceneGroup:insert( checkPad2 )

    

    local function padTouched(self, event)

        digital.setTime(analog.getTime())
        
    end


    checkPad.touch = padTouched
    checkPad:addEventListener("touch", checkPad)

    local function padTouched(self, event)
        local function listener( event )
             analog.setTime(digital.getTime())
        end

        timer.performWithDelay( 1, listener )


    end


    checkPad2.touch = padTouched
    checkPad2:addEventListener("touch", checkPad2)


    local menu = display.newImageRect( "images/menu.png",
            _H*.1,  _H*.1)
    menu.x, menu.y = _W*.9, _H*.1
    local function listener()
        composer.gotoScene( "menu" )
    end
    menu:addEventListener( "tap", listener )
    sceneGroup:insert( menu )

    local menu = display.newImageRect( "images/change_page.png",
            _H*.1,  _H*.1)
    menu.x, menu.y = _W*.9, _H*.9
    local function listener()
        composer.gotoScene( "lessons.lesson11" )
    end
    menu:addEventListener( "tap", listener )
    sceneGroup:insert( menu )
  
    
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
