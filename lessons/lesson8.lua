-- tens version of lesson 5
-- subtraction lesson

local composer = require( "composer" )
local numLine = require( "objects.tennumline" )
local animal = require("objects.animal")
local animalball = require("objects.animalball")
local bucket = require( "objects.bucket")
local numInput = require( "objects.tripleinput")
local widget = require "widget"
local physics = require "physics"
local openssl = require( "plugin.openssl" )
local cipher = openssl.get_cipher ( "aes-256-cbc" )
physics.start()
--physics.setDrawMode( "hybrid" )
physics.setTimeStep( 1/10 )

local numCorr = 0
local numWrong = 0
local answerText

local scene = composer.newScene()
local hasCollidedCircle
local ballSize = ballR*1.75

local max = 10
local count = max -- math.random( 1, max)
math.randomseed(os.time())
local numberOne = math.random( 1, max )*10
local numberTwo = math.random( 0, max )*10
-- preventing negative result
while ( numberTwo >= numberOne ) do
    print( "negative result" )
    numberTwo = math.random( 0, max ) *10
end
local total = numberOne + numberTwo
local result = numberOne - numberTwo
local matchCount = count
local outsideX, outsideY = _W*.6, _H*.75
local outsideStep = 0

local countBalls = {}
local matchBalls = {}
local numberLine
local displayText = {}
--local bucket
local bucket1
local bucket2
local bucketY = _H*.25
local bucketY3 = _H*.7
local bucketX1 = _W*.15
local bucketX2 = _W*.5
local bucketX3 = _W*.32
local num1
local num2
local subtract
local input
local numberLine
local question
local equal

local sceneGroup

local decText
local latText

local selText = display

local timers = {}

local function cancelAll()
	for k, v in pairs(timers) do
		timer.cancel(v);
	end
	transition.cancel();
end

local function onLocalCollision( self, event )
   local t = event.target
   local o = event.other

    if event.other.name == "minus" then
        display.remove(event.other)
        event.other = nil
        local x = display.newImageRect( "images/redX.png", ballSize, ballSize)
        event.target:insert(x)

        local function onTimer( event )
            local params = event.source.params
            physics.removeBody( params.passedTar )
            params.passedTar.name =  "minus"
        end

        local tm = timer.performWithDelay( 1, onTimer )

        tm.params = { passedTar = event.target }
        transition.to( event.target, { time=750, x=outsideX + outsideStep, y=outsideY } )
        outsideStep = outsideStep + ballR*2
    end

end

function reset()

	clearBalls()
  	initBalls()
    input.reset()
    input.x = _W*.8
    physics.start()
    numberLine.y = -bucketY
    num1.y = bucketY
    num2.y = bucketY
    num1:toFront()
    num2:toFront()
    subtract.y = bucketY
    question.text = "?"
    question.y = bucketY3
    equal.y = _H*.7
    displayText.text = ""
    question:setFillColor(0,0,0)
    outsideStep = 0

end

function check()

    local delayTime = 5000
    local stepTime = 400
     transition.to( bucket1, { time=500, rotation = 90 } )
    transition.to( bucket2, { time=500, rotation = -90 } )
    transition.to( input, { time=1000, x = _W*1.25} )
    question.text = input.getNumber()
    question.text = input.getNumber()


    transition.to( bucket1, { delay = delayTime, time=1000, y = -bucketY } )
    transition.to( bucket2, { delay = delayTime, time=1000, y = -bucketY } )
    transition.to( num1, { delay = delayTime, time=1000, y = -bucketY } )
    transition.to( num2, { delay = delayTime, time=1000, y = -bucketY } )
    transition.to( subtract, { delay = delayTime, time=1000, y = -bucketY } )
    transition.to( numberLine, { delay = delayTime, time=1000, y = bucketY } )

    local function reNumberBalls ( event )
        local count = 0
        local mCount = (numberOne - numberTwo)/10
        local max = 1
        for i=1, (numberOne+numberTwo)/10 do

            if matchBalls[i].name ~= "minus" then
                count = count + 1
                matchBalls[i].text.text = count * 10
                matchBalls[i].num = count
                print(matchBalls[i].num)
                max = i
            else
                mCount = mCount + 1
                matchBalls[i].text.text = mCount * 10
                matchBalls[i].num = mCount
            end

        end

    end

    timers[#timers + 1] = timer.performWithDelay( delayTime*.75, function (event) reNumberBalls() end)
    timers[#timers + 1] = timer.performWithDelay( delayTime, function (event) physics.pause() end)

    timers[#timers + 1] = timer.performWithDelay( delayTime, function (event)
        for i=1, (numberOne+numberTwo)/10 do
            transition.to( matchBalls[i], { time=1000,  x = numberLine.hash[matchBalls[i].num].x + numberLine.x, y = bucketY + ballR, rotation = 0} )
        end
    end)


    timers[#timers + 1] = timer.performWithDelay( delayTime + 1000,  function (event)
            for j=1,(numberOne - numberTwo)/10 do
            timers[#timers + 1] = timer.performWithDelay(j * stepTime, function (event) displayText.text = convertDecToLat(j *10) end)

            for i = 1, (numberOne+numberTwo)/10 do
                if matchBalls[i].num == j then
                    timers[#timers + 1] = timer.performWithDelay(j * stepTime,
                        function (event)
                        matchBalls[i].outline:setFillColor(hlColor.R, hlColor.G, hlColor.B)
                        matchBalls[i].outline.alpha = 1
                    end)
                end
            end
        end

    end)

    if (numberOne-numberTwo) == input.getNumber() then
        timers[#timers + 1] = timer.performWithDelay( (delayTime + 1000 + ((numberOne-numberTwo)/10) * stepTime), function (event)
            question:setFillColor(Green.R,Green.G,Green.B)
            end)
        numCorr = numCorr + 1
    else
        timers[#timers + 1] = timer.performWithDelay( (delayTime + 1000 + ((numberOne-numberTwo)/10) * stepTime), function (event)
            question:setFillColor(Red.R,Red.G,Red.B)
            end)
         numWrong = numWrong + 1
    end
    answerText.text = numCorr .. "/" .. (numCorr + numWrong)
    local textData = cipher:encrypt ( answerText.text, "sbs_math_key" )
    local userUpdate = [[ UPDATE users SET lesson8 = ']] .. textData ..[[' WHERE id = ']] .. currentID .. [['; ]]
    db:exec( userUpdate )

	timers[#timers + 1] = timer.performWithDelay( (delayTime + 3000+ ((numberOne-numberTwo)/10) * stepTime), function (event) reset() end)

end


function initBalls()



            for i = 1, numberOne/10 do

                matchBalls[i] = Animal:new("images/ball.png", ballSize, ballSize, ballSize*.75)
                matchBalls[i].x, matchBalls[i].y = bucketX1 + math.random(-50, 50), bucketY - 2 * ballR*i
                physics.addBody( matchBalls[i], { radius=ballSize*.5 , friction = .5} )
                matchBalls[i].text.text = i * 10
                 matchBalls[i].collision = onLocalCollision
                 matchBalls[i]:addEventListener( "collision", matchBalls[i] )
                sceneGroup:insert( matchBalls[i] )

            end

            for i = numberOne/10 + 1, total/10 do

                matchBalls[i] = Animal:new("images/redX.png", ballSize, ballSize, ballSize*.75)
                matchBalls[i].name = "minus"
                matchBalls[i].x, matchBalls[i].y = bucketX2 + math.random(-50, 50), bucketY - 2 * ballR*i
                physics.addBody( matchBalls[i], { radius=ballSize*.5, friction = .5 } )
                matchBalls[i].text.text = i *10 - numberOne
                sceneGroup:insert( matchBalls[i] )

            end

end

function clearBalls()
    bucket1.rotation = 0
    bucket2.rotation = 0
    bucket1.y = bucketY
    bucket2.y = bucketY

    local i=1
    for k,v in pairs(matchBalls) do
        display.remove(matchBalls[i])
        matchBalls[i] = nil
        i=i + 1
    end

    numberOne = math.random( 1, max )*10
    numberTwo = math.random( 0, max )*10
    -- preventing negative result
    while ( numberTwo >= numberOne ) do
        print( "negative result" )
        numberTwo = math.random( 0, max )*10
    end
    total = numberOne + numberTwo
    result = numberOne - numberTwo
    num1.text = numberOne
    num2.text = numberTwo

end
-- "scene:create()"
function scene:create( event )

    sceneGroup = self.view

    physics.start()
    count = math.random(1,max)
    matchCount = count

     for row in db:nrows("SELECT * FROM users") do
        local userData = cipher:decrypt ( row.username, "sbs_math_key" )  
        local lessonData = cipher:decrypt ( row.lesson8, "sbs_math_key" )  
            if userData == currentUser  then
                print("VALID USER: " .. userData .. " : " .. lessonData )
                local split = string.find(lessonData, "/")
                numCorr =  tonumber( lessonData:sub( 1 , split-1 ) )
                numWrong =  tonumber( lessonData:sub( split+1 ) ) - numCorr
            end
    end

    local background = display.newImageRect( "images/bg_blue_zig.png",
            display.contentWidth, display.contentHeight )
    background.anchorX = 0
    background.anchorY = 0
    background.x, background.y = 0, 0
    sceneGroup:insert( background )

    answerText = display.newText(" ", _W * .75, _H * .1, font, _W*.02)
    sceneGroup:insert(answerText)


    displayText = display.newText("", _W * .5, _H * .125, font, _W*.07)
    displayText:setFillColor( 0, 0, .5 )

    sceneGroup:insert(displayText)


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

    input = numInput:new(2, _W*.80,centerY)
    sceneGroup:insert( input )

    bucket1 = bucket:new(ballR*8,ballR*8)
    bucket1.x, bucket1.y = bucketX1, bucketY
    sceneGroup:insert( bucket1)

    bucket2 = bucket:new(ballR*8,ballR*8)
    bucket2.x, bucket2.y = bucketX2, bucketY
    sceneGroup:insert( bucket2)

    bucket3 = bucket:new(ballR*8,ballR*8)
    bucket3.x, bucket3.y = bucketX3, bucketY3
    sceneGroup:insert( bucket3)

    -- subtraction sign
    subtract = display.newText( "-", _W*.32, _H*.25, font, _W*.15 )
    subtract:setFillColor( 0,0,0 )
    sceneGroup:insert(subtract)

    -- equal sign
    equal = display.newText( "=", _W*.15, _H*.7, font, _W*.15 )
    equal:setFillColor( 0,0,0 )
    sceneGroup:insert(equal)

     -- question mark
    num1 = display.newText( numberOne, bucketX1, bucketY, font, _W*.15 )
    num1:setFillColor( 0,0,0, .5 )


     -- question mark
    num2 = display.newText( numberTwo, bucketX2, bucketY, font, _W*.15 )
    num2:setFillColor( 0,0,0, .5 )
    sceneGroup:insert(num2)


    -- question mark
    question = display.newText( "?", bucketX3, bucketY3, font, _W*.15 )
    question:setFillColor( 0,0,0, .5 )
    sceneGroup:insert(question)


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
    sceneGroup:insert( num1 )
    sceneGroup:insert( num2 )

    numberLine =  numLine:new(0, 20, _W*.9, 0, fontSize*.5 )
    numberLine.x , numberLine.y = _H*.1, -bucketY
    sceneGroup:insert(numberLine)

    local overCheck = display.newRect( 0, 0, _W*.09, _W*.09)
    overCheck.x, overCheck.y = _W*.8, input.getCheckY() + input.y
    overCheck.alpha = .005
    sceneGroup:insert(overCheck)


    function overCheck:tap( event )

        local user = input.getNumber()

        check()



        if result == user then
            print ( "CORRECT")
        else
            print ( "NEGATIVE" )
        end
    end

overCheck:addEventListener( "tap", overCheck )

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
    physics.setTimeStep( -1 )


   -- display.remove(sceneGroup)
   -- composer.removeAll()

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
