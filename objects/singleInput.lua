-- singleInput.lua
-- two digit number box for allowing user to select a number
-- max of leftmost digit, x, and y can be set during instanciation
-- example:
-- local singleInput = require( "objects.singleInput" )
-- local boxTest = singleInput.new( 6, -190, 40 )
------------------------------------------------------------
local singleInput = {}
local widget = require( "widget" )

local rightNum = 0
local strokeC = { 1, 0, 0.5 } --RGB, change or remove for final draft
_G.finalNumber = 0

function singleInput:new( x, y ) -- constructor

    local countBox = display.newGroup()
    countBox.num = 0

    -- Handle number stepper events
    local function onStepperPress( event )
        local id = event.target.id

        --increments on right plus press
        if id == "RightPlus" and rightNum < 9 then
            rightNum = rightNum + 1
            numTxtR.text = rightNum
            print( rightNum ) -- can remove this line
        end

        --increments on right plus press
        if id == "RightMinus" and rightNum > 0 then
            rightNum = rightNum - 1
            numTxtR.text = rightNum
            print( rightNum ) -- can remove this line
        end

        return true
    end


    -- rectanglular outer box, adjust looks as needed for final draft
    -- paremeters: parent, x, y, width, height
    local boxW = _W*0.15
    local boxH = _W*0.32
    local checkY = boxH*.55

    -- invisible box for containing other elements
    local box = display.newRect(countBox, 0, 0, boxW, boxH )
        box.alpha = 0
        
    -- buttons, adjust looks as needed for final draft
    local plusButtonR = widget.newButton{
                    id = "RightPlus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/plus.png",
                    overFile="images/plus.png", -- not needed
                    onPress = onStepperPress,
            }
        plusButtonR.x = 0
        plusButtonR.y = -boxH*.25

    local minusButtonR = widget.newButton{
                    id = "RightMinus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/minus.png",
                    overFile="images/minus.png", -- not needed
                    onPress = onStepperPress,
            }
        minusButtonR.x = 0
        minusButtonR.y = boxH*.25

    local checkButton = widget.newButton{
                    id = "CheckButton",
                    width = _W*.05,
                    height = _W*.05,
                    defaultFile="images/check.png",
                    overFile="images/check.png" -- not needed
                    --onPress = onCheck,
            }
        checkButton.x = 0
        checkButton.y = checkY
        
    -- grey shadow behind right number    
    local rightShadow = display.newRect (countBox, 0, 0, boxW*.45, boxH*.4)
        rightShadow:setFillColor( 0, 0, 0 )
        rightShadow.alpha = 0.5
        rightShadow.x = 0

    countBox:insert( plusButtonR )
    countBox:insert( minusButtonR )
    countBox:insert( checkButton )
    countBox:insert( rightShadow )

    numTxtR = display.newText( rightNum, 0, 0, default, _W*.07 )
            numTxtR:setFillColor( 0 )
            numTxtR.x = 0
            numTxtR.y = 0

    countBox:insert ( numTxtR )

    countBox.x = x
    countBox.y = y

    function countBox.getNumber()
        return rightNum
    end

    function countBox.getCheckY()
        return checkY
    end

    function countBox.reset()
         numTxtR.text = 0
         rightNum = 0 
    end

    return countBox
end



return singleInput


