local composer = require( "composer" )
local numLine = require( "objects.numLine" )
local animal = require("objects.animal")
local animalball = require("objects.animalball")
local physics = require "physics"
physics.start()
--physics.setDrawMode( "hybrid" )


local scene = composer.newScene()

local hasCollidedCircle

local max = 10
local count = max -- math.random( 1, max)
local matchCount = count
local map = { false, false, false, false, false, false, false, false, false, false,  false, false, false, false, false }

local countBalls = {}
local matchBalls = {}
local numberLine
local displayText = {}

local sceneGroup

local decText
local latText

local selText = display

local function drag( event )
    local t = event.target

    -- Print info about the event. For actual production code, you should
    -- not call this function because it wastes CPU resources.
    --printTouch(event)

    local phase = event.phase
    if "began" == phase then
        -- Make target the top-most object
        local parent = t.parent
        parent:insert( t )
        display.getCurrentStage():setFocus( t )

        decText.text = t.num
        local text = convertDecToLat( t.num )
        latText.text = text
        -- Spurious events can be sent to the target, e.g. the user presses
        -- elsewhere on the screen and then moves the finger over the target.
        -- To prevent this, we add this flag. Only when it's true will "move"
        -- events be sent to the target.
        t.isFocus = true

        -- Store initial position
        t.x0 = event.x - t.x
        t.y0 = event.y - t.y
    elseif t.isFocus then
        if "moved" == phase then
            -- Make object move (we subtract t.x0,t.y0 so that moves are
            -- relative to initial grab point, rather than object "snapping").
            t.x = event.x - t.x0
            t.y = event.y - t.y0

        elseif "ended" == phase or "cancelled" == phase then

                print(t.cooldedWith)

                if(t.collidedWith ~= nil) then

                    hasCollidedCircle(t, t.collidedWith )

                end

            display.getCurrentStage():setFocus( nil )
            t.isFocus = false
        end
    end

    -- Important to return true. This tells the system that the event
    -- should not be propagated to listeners of any objects underneath.
    return true
end

local function onLocalCollision( self, event )
   local t = event.target
   local o = event.other

    if ( event.phase == "began" ) then

        if (event.other.matched == false) then
            event.other.num = self.num
            self.collidedWith = event.other

        end

    elseif ( event.phase == "ended" ) or ( event.phase == "cancelled" ) then

        if (event.other.matched == false) then
            event.other.num = self.num
            self.collidedWith = event.other
        end

    end
end


function hasCollidedCircle(obj1, obj2)

    if obj1 == nil then
        return false
    end

    if obj2 == nil then
        return false
    end

    local sqrt = math.sqrt
    local dx =  obj1.x - obj2.x;
    local dy =  obj1.y - obj2.y;
    local distance = sqrt(dx*dx + dy*dy);
    local objectSize = (obj2.contentWidth/2) + (obj1.contentWidth/2)

    if distance < objectSize then

                    local function listener( event )
                        display.remove(obj1)
                    end


                    local transitionTime = 100


                    transition.to(obj1,
                    {
                        time=transitionTime,
                        x = obj2.x,
                        y= obj2.y,
                        onComplete = listener
                    })

                   obj2.text.text = obj1.num--= display.newText( obj1.num, 0, 0, font, ballR*2 )
                    obj2.text:setFillColor(0,0,0)
                    obj2.text.alpha = 0
                    obj2.num = obj1.num
                    obj2:insert( obj2.text )
                    obj2.matched = true


                    local function listener( event )
                        transition.to(obj2.text,
                        {
                        time=500,
                        alpha =.75
                        })
                    end
                    timer.performWithDelay( transitionTime, listener )

                    matchCount = matchCount - 1

                    if matchCount <= 0 then
											decText.text = ""
											latText.text = ""
                      check()
											matchCount = count
                    end
        print("true")
        return true
    end
    return false
end

function reset()
	displayText.text = ""
	clearBalls()
	count = math.random(1,max)
    	matchCount = count
  	initBalls()
end

function check()

	for i=1, count do
			local distance = math.pow( (math.pow( matchBalls[i].x - numberLine.x, 2 ) + math.pow( matchBalls[i].y, 2 )), .5  )
			local time = distance/maxSpeed*1000
			--print( numberLine.num[i].text .. " : ".. distance .. " : ".. time)
                        -- "-30" in transition below sets the offset from numberline when dogs move to line
                        --transition.moveTo( matchBalls[i], {x = numberLine.hash[matchBalls[i].num].x + numberLine.x, y = numberLine.hash[matchBalls[i].num].y + numberLine.y -30, time=1000})
                        -- line below does slower 3D effect transision
                        transition.matTrans( matchBalls[i], numberLine.hash[matchBalls[i].num].x + numberLine.x,  numberLine.y + 2*ballR, time )
                        --numberLine.hash[matchBalls[i].num].y +
	end

	for j=1,count do
		timer.performWithDelay(j * 1000, function (event) displayText.text = convertDecToLat(j) end)

        for i = 1, count do
            if matchBalls[i].num == j then
                timer.performWithDelay(j * 1000,
                    function (event)
                    matchBalls[i].outline:setFillColor(hlColor.R, hlColor.G, hlColor.B)
                    matchBalls[i].outline.alpha = 1
                end)
            end
        end
	end

	local currScene = composer.getSceneName( "current" )
	print(currScene)
	timer.performWithDelay((count + 1) * 1000, function (event) reset() end)

end

function initBalls()
	    for i=1,count do
	        countBalls[i] = AnimalBall:new(0,0, ballR*1.5, i)
	        countBalls[i]:addEventListener( "touch", drag )

	        countBalls[i]:insert( countBalls[i].ball )
	        countBalls[i]:insert( countBalls[i].text )


	        countBalls[i].x, countBalls[i].y = numberLine.num[i].x + numberLine.x, numberLine.num[i].y + numberLine.y 

	        physics.addBody( countBalls[i], { radius=ballR*1.5 } )
	        countBalls[i].isSensor = true
	        countBalls[i].collision = onLocalCollision
	        countBalls[i]:addEventListener( "collision", countBalls[i] )

	        sceneGroup:insert(countBalls[i])
	    end

			map = { false, false, false, false, false, false, false, false, false, false,  false, false, false, false, false }

	    for i=1,count do
	        matchBalls[i] = Animal:new("images/puppy.png",  ballR*3, ballR*3, ballR*2)
	        matchBalls[i]:addEventListener( "touch", drag )
	        matchBalls[i]:insert( matchBalls[i].ball )

	        --places balls in grid
	        while  matchBalls[i].x == 0 and  matchBalls[i].y == 0 do

	            local randomLocation = math.random(1, 15)

	            if map[randomLocation] == false then
	                --matchBalls[i].x, matchBalls[i].y = _W *.5 /6 +  _W *.5 /3 * (randomLocation % 3), _H*.1 + _H*.2*math.floor((randomLocation-1) / 3)
										matchBalls[i].x, matchBalls[i].y = _W*.05 + _W*.1*math.floor((randomLocation-1) / 3), _H *.5 / 6 + _H * .5 / 3 * (randomLocation % 3) + _H *.5
										map[randomLocation] = true

	            end

	        end

	        physics.addBody( matchBalls[i], { radius=ballR*1.25 } )

	        sceneGroup:insert( matchBalls[i] )
	    end
end

function clearBalls()
	for i=1, count do
		sceneGroup:remove(matchBalls[i])
		matchBalls[i] = nil
	end
end
-- "scene:create()"
function scene:create( event )

    sceneGroup = self.view
		displayText = display.newText("", _W * .5, _H * .125, font, _W*.1)
                displayText:setFillColor( 0, 0, 0 )
    physics.setGravity(0,0)

    local background = display.newImageRect( "images/bg_blue_zig.png",
            display.contentWidth, display.contentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    sceneGroup:insert( background )

    --local coordinates =
    numberLine =  numLine:new(0, 10, _W*.85, 0 )
    numberLine.x , numberLine.y = _H*.125, _W*.2
    sceneGroup:insert(numberLine)

    decText  = display.newText( "", 0, 0, font, _W*.1 )
    decText.x, decText.y = _W*.833, _H*.6
    decText:setFillColor( 0, 0, 0 )
    sceneGroup:insert( decText )

    latText = display.newText( "", 0, 0, font, _W*.1 )
    latText.x, latText.y = _W*.833, _H*.75
    latText:setFillColor( 0, 0, 0 )
    sceneGroup:insert( latText )
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
 		initBalls()
end


-- "scene:show()"
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


-- "scene:hide()"
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


-- "scene:destroy()"
function scene:destroy( event )

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
