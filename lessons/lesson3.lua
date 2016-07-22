local composer = require( "composer" )
local numLine = require( "objects.numline" )
local animal = require("objects.animal")
local animalball = require("objects.animalball")
local compball = require("objects.compball")
local compball = require("objects.compballput")
local physics = require "physics"
physics.start()
--physics.setDrawMode( "hybrid" )

local hasCollidedCircle

local scene = composer.newScene()

local max = 4
local count1 = math.random( 1, max)
local count2 = math.random( 1, max)
local matchCount = count
local map1 = { false, false, false, false, false, false, false, false, false, false,  false, false, false, false, false }
local map2 = { false, false, false, false, false, false, false, false, false, false,  false, false, false, false, false }
local leftBound = _W*.375   -- Used to calculate the left  bounds of the draggable elements
local rightBound = _W*.625  -- Used to calculate the right bounds of the draggable elements


local countBalls = {}
local matchBalls1 = {}
local matchBalls2 = {}

local eq
local gt
local lt
local guess = ""

local put

local numLine1
local numLine2

local displayText1
local displayText2

local sceneGroup

local decText1
local decText2

local latText1
local latText2

local area

local timers = {}

local function cancelAll()
	for k, v in pairs(timers) do
		timer.cancel(v);
	end
	transition.cancel();
end

function check()

	local correct
	if count1 > count2 then
		correct = ">"
	elseif count1 < count2 then
		correct = "<"
	else
		correct = "="
	end

	local answer = false
	if correct == put.operator then
		answer = true
	end

	for i=1, count1 do
		local distance = math.pow( (math.pow( matchBalls1[i].x - numLine1.x, 2 ) + math.pow( matchBalls1[i].y, 2 )), .5  )
		local time = distance/maxSpeed*1000
		transition.moveTo( matchBalls1[i], {x = numLine1.hash[matchBalls1[i].num].x + numLine1.x, y = numLine1.hash[matchBalls1[i].num].y + numLine1.y, time=1000})
	end
	for j=1, count2 do
		local distance = math.pow( (math.pow( matchBalls2[j].x - numLine2.x, 2 ) + math.pow( matchBalls2[j].y, 2 )), .5  )
		local time = distance/maxSpeed*1000
		transition.moveTo( matchBalls2[j], {x = numLine2.hash[matchBalls2[j].num].x + numLine2.x, y = numLine2.hash[matchBalls2[j].num].y + numLine2.y, time=1000})
	end

	local max = math.max( count1, count2 )
	local min = math.min( count1, count2 )
	for k=1, max do
		if answer == false then
			displayText1:setFillColor(Red.R, Red.B, Red.G)
			displayText2:setFillColor(Red.R, Red.B, Red.G)
		end
		if k <= count1 then
			timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) displayText1.text = convertDecToLat(k) end)
                        timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) matchBalls1[k].outline:setFillColor(hlColor.R, hlColor.G, hlColor.B) end)
                        timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) matchBalls1[k].outline.alpha = 1 end)
		end

                -- added extra delay to hold count for right side until left is finished
                timers[#timers + 1] = timer.performWithDelay( count1 * 1000, function (event)
                    if k <= count2 then
                            timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) displayText2.text = convertDecToLat(k) end)
                            timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) matchBalls2[k].outline:setFillColor(hlColor.R, hlColor.G, hlColor.B) end)
                            timers[#timers + 1] = timer.performWithDelay(k * 1000, function (event) matchBalls2[k].outline.alpha = 1 end)
                    end
                end)


	end
	timers[#timers + 1] = timer.performWithDelay((count1 + count2 - 1) * 1000, function (event)
		if (count1 < count2 and put.operator == "<") or (count1 == count2 and put.operator == "=") or (count1 > count2 and put.operator == ">") then
			put.ball:setFillColor(Green.R, Green.G, Green.B);
		else
			put.ball:setFillColor(Red.R, Red.G, Red.B);
		end
	end)
	timers[#timers + 1] = timer.performWithDelay((count1 + count2 + 2) * 1000 + 500, function (event) clearBalls() initBalls() end)
end



local function onLocalCollision( self, event )
   local t = event.target
   local o = event.other

    if ( event.phase == "began" ) then

        if (event.other.matched == false) then
						event.other.operator = self.operator
            self.collidedWith = event.other

        end

    elseif ( event.phase == "ended" ) or ( event.phase == "cancelled" ) then

        if (event.other.matched == false) then
						event.other.operator = self.operator
            self.collidedWith = event.other
        end

    end
end

local function drag( event )
  local t = event.target

	local phase = event.phase
	if "began" == phase then
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )

		t.isFocus = true

		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
            -- Make sure objects don't move beyond the bounds
            if (event.x < leftBound and t.type == "comp") then
                t.x = leftBound
            elseif (event.x > rightBound and t.type == "comp") then
                t.x = rightBound
            else
                t.x = event.x - t.x0
            end
            			-- Causing issues
						if t.hovered == false and t.x - put.x <= 1 and t.y - put.y <= 1 then
							t.hovered = true
						end

			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			print(t.collidedWith);
			if(t.collidedWith ~= nil) then
				--	hasCollidedCircle(t, t.collidedWith )
			end
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false

			if t.hovered == true then
				put.operator = t.operator
				put.text.text = put.operator
				guess = t.operator
				sceneGroup:remove(eq)
				sceneGroup:remove(lt)
				sceneGroup:remove(gt)
				check()
			end
		end
	end

-- Important to return true. This tells the system that the event
-- should not be propagated to listeners of any objects underneath.
	return true
end

function clearBalls()
	if eq.isVisible then
	sceneGroup:remove(eq)
	end
	if lt.isVisible then
	sceneGroup:remove(lt)
	end
	if gt.isVisible then
	sceneGroup:remove(gt)
	end
	for i=1, count1 do
		sceneGroup:remove(matchBalls1[i])
		matchBalls1[i] = nil
	end
	for j=1, count2 do
		sceneGroup:remove(matchBalls2[j])
		matchBalls2[j] = nil
	end
	displayText1.text = ""
	displayText2.text = ""
	displayText1:setFillColor(priColor.R,priColor.G,priColor.B)
	displayText2:setFillColor(priColor.R,priColor.G,priColor.B)
	count1 = math.random( 1, max)
	count2 = math.random(1, max)
	put.operator = ""
	put.text.text = ""
end

function initBalls()

	eq = CompBall:new("=", ballR*1.5)
    eq.type = "comp"
	eq:addEventListener( "touch", drag )
	eq.isSensor = true
	eq.hovered = false
	eq.collision = onLocalCollision
	eq:addEventListener("collision", eq)
	physics.addBody( eq, { radius=ballR*1.5 } )
	eq:insert(eq.ball)
	eq:insert(eq.text)
	sceneGroup:insert(eq)
	eq.x, eq.y = _W * .5, _H * .5 - ballR * 4.5

	lt = CompBall:new("<", ballR*1.5)
    lt.type = "comp"
	lt:addEventListener( "touch", drag )
	lt.isSensor = true
	lt.hovered = false
	lt.collision = onLocalCollision
	lt:addEventListener("collision", lt)
	physics.addBody( lt, { radius=ballR*1.5 } )
	lt:insert(lt.ball)
	lt:insert(lt.text)
	sceneGroup:insert(lt)
	lt.x, lt.y = _W * .5 - ballR * 3, _H * .5 - ballR * 4.5

	gt = CompBall:new(">", ballR*1.5)
	gt:addEventListener( "touch", drag )
    gt.type = "comp"
	gt.isSensor = true
	gt.hovered = false
	gt.collision = onLocalCollision
	gt:addEventListener("collision", gt)
	physics.addBody( gt, { radius=ballR*1.5 } )
	gt:insert(gt.ball)
	gt:insert(gt.text)
	sceneGroup:insert(gt)
	gt.x, gt.y = _W * .5 + ballR * 3, _H * .5 - ballR * 4.5

	put = CompBallPut:new(ballR * 1.5)
	put.collision = onLocalCollision
	put:addEventListener("collision", put)
    physics.addBody( put, { radius=ballR*1.5 } )
    put.isSensor = true
    lt:insert(lt.ball)
	put:insert(put.ball)
	put:insert(put.text)
	put.x, put.y = _W * .5, _H * .5 + ballR * 1
	sceneGroup:insert(put)

        -- left group of animals
        for i=1,count1 do
            matchBalls1[i] = Animal:new("images/puppy.png",  ballR*3, ballR*3, ballR*2)
						matchBalls1[i].num = i
            matchBalls1[i]:addEventListener( "touch", drag )
            matchBalls1[i]:insert( matchBalls1[i].ball )

            --places balls in grid
            while  matchBalls1[i].x == 0 and  matchBalls1[i].y == 0 do

                local randomLocation = math.random(1, 15)

                if map1[randomLocation] == false then
                    --matchBalls[i].x, matchBalls[i].y = _W *.5 /6 +  _W *.5 /3 * (randomLocation % 3),
                        --_H*.1 + _H*.2*math.floor((randomLocation-1) / 3)
                    matchBalls1[i].x, matchBalls1[i].y = leftBound*.65 - math.random(_W*.2), -- _W*math.random(_W*.1), --+ _W*.1*math.floor((randomLocation-1) / 3),
                        _H *.5 / 6 + _H * .5 / 3 * (randomLocation % 3) + _H *.01
                    map1[randomLocation] = true

                end

            end

            physics.addBody( matchBalls1[i], { radius=ballR*1.25 } )

            sceneGroup:insert( matchBalls1[i] )
        end

        -- right group of animals
        for i=1,count2 do
            matchBalls2[i] = Animal:new("images/mouse.png",  ballR*3, ballR*3, ballR*2)
						matchBalls2[i].num = i
            matchBalls2[i]:addEventListener( "touch", drag )
            matchBalls2[i]:insert( matchBalls2[i].ball )

            --places balls in grid
            while  matchBalls2[i].x == 0 and  matchBalls2[i].y == 0 do

                local randomLocation = math.random(1, 15)

                if map2[randomLocation] == false then
                    --matchBalls[i].x, matchBalls[i].y = _W *.5 /6 +  _W *.5 /3 * (randomLocation % 3),
                        --_H*.1 + _H*.2*math.floor((randomLocation-1) / 3)
                    matchBalls2[i].x, matchBalls2[i].y = rightBound*1.25 + math.random(_W*.15),--_W*.05 + _W*.1*math.floor((randomLocation-1) / 3),
                        _H *.5 / 6 + _H * .5 / 3 * (randomLocation % 3) + _H *.01
                    map2[randomLocation] = true

                end

            end

            physics.addBody( matchBalls2[i], { radius=ballR*1.25 } )

            sceneGroup:insert( matchBalls2[i] )
        end

        print(count1)
        print(count2)
end

function scene:create( event )
 	sceneGroup = self.view
	physics.setGravity(0,0)


    local background = display.newImageRect( "images/bg_blue_zig.png",
            display.contentWidth, display.contentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    sceneGroup:insert( background )

    local menu = display.newImageRect( "images/menu.png",
            _H*.1,  _H*.1)
    menu.x, menu.y = _W*.9, _H*.1
    local function listener()
				cancelAll()
				sceneGroup:removeSelf()
        composer.gotoScene( "menu" )
    end
    menu:addEventListener( "tap", listener )
    sceneGroup:insert( menu )

	numLine1 = numLine:new(0, 10, _H*.9, 90, 1, fontSize )
	numLine1.anchorX, numLine1.anchorY = 0.5, 0.5
	numLine1.x , numLine1.y = leftBound - _W*.07, _H * .05

	for p=0,10 do
		numLine1.num[p].x = -80
	end

	sceneGroup:insert(numLine1)

	numLine2 =  numLine:new(0, 10, _H*.9, 90, 1, fontSize )
	numLine2.anchorX, numLine2.anchorY = 0.5, 0.5
	numLine2.x , numLine2.y = rightBound + _W*.07, _H * .05

	sceneGroup:insert(numLine2)

	displayText1 = display.newText("", _W * .15, _H * .2, font, _W*.05)
	displayText2 = display.newText("", _W * .85, _H * .2, font, _W*.05)

	displayText1:setFillColor(priColor.R,priColor.G,priColor.B)
	displayText2:setFillColor(priColor.R,priColor.G,priColor.B)

	sceneGroup:insert(displayText1)
	sceneGroup:insert(displayText2)

local options =
{
    --required parameters
    width = (rightBound - leftBound),
    height = _H,
    numFrames = 2,

    --optional parameters; used for scaled content support
    sheetContentWidth = _W,  -- width of original 1x size of entire sheet
    sheetContentHeight = _H   -- height of original 1x size of entire sheet
}

local imageSheet = graphics.newImageSheet( "images/bg_green_stripes3.png", options )

	local area = display.newImage( imageSheet, 1)
    area.x, area.y = _W * .5, _H * .5
    sceneGroup:insert( area )

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

	--composer.removeAll()


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

return scene
