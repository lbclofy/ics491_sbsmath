local composer = require( "composer" )
local snake = require("objects.snake")
local bucket = require("objects.bucketObject")
local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")

local scene = composer.newScene()

local maxNumSnakes = 4
local snakes = {}
local shortBucket = {}
local longBucket = {}
local randomCount
local snakesLeft

local shortText
local longText

local function onLocalCollision( self, event )
   local t = event.target
   local o = event.other

    if ( event.phase == "began" ) then
			self.collidedWith = event.other
    elseif ( event.phase == "ended" ) or ( event.phase == "cancelled" ) then
			self.collidedWith = event.other
    end
end

function hasCollided(obj1, obj2)
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


								local transitionTime = 100


								transition.to(obj1,
								{
										time=transitionTime,
										x = obj2.x,
										y= obj2.y,
										onComplete = listener
								})

								snakesLeft = snakesLeft - 1

								if snakesLeft <= 0 then
									check()
									snakesLeft = randomCount
								end
		print("true")
		return true
end
return false
end



function check()
end

function initSnakes()

	randomCount = math.random(2, maxNumSnakes)
	snakesLeft = randomCount
	for i=1, randomCount do
		snakes[i] = {}
		if math.random(1,2) == 1 then
			snakes[i] = Snake:new(5)
		else
			snakes[i] = Snake:new(10)
		end
		snakes[i].x = math.random(_W*.25, _W*.75)
		snakes[i].y = math.random(_H*.25, _H*.75)
		snakes[i].hovered = false
		snakes[i].collision = onLocalCollision
		snakes[i].collidedWith = nil
		physics.addBody( snakes[i], { radius=4 * _H * .075 * .5 } )
		
		snakes[i]:insert(snakes[i].img);
		sceneGroup:insert( snakes[i] )

	end
end

function scene:create( event )
	sceneGroup = self.view

	shortBucket = bucketObj:new(_W*.25,_H*.65)
	longBucket = bucketObj:new(_W*.75,_H*.65)

	shortBucket.collision = onLocalCollision
	longBucket.collision = onLocalCollision

	shortBucket:addEventListener("collision", shortBucket)
	longBucket:addEventListener("collision", longBucket)

	physics.addBody( shortBucket, { radius=1.5 } )
	physics.addBody( longBucket, { radius=1.5 } )

	shortBucket.isSensor = true
	longBucket.isSensor = true

	sceneGroup:insert(shortBucket)
	sceneGroup:insert(longBucket)

	shortText = display.newText("short",_W*.25,_H*.85, font, _W*.05);
	longText = display.newText("long",_W*.75,_H*.85, font, _W*.05);
	shortText:setFillColor(priColor.R, priColor.G, priColor.B)
	longText:setFillColor(priColor.R, priColor.G, priColor.B)
	physics.setGravity(0,0)
	initSnakes()
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
