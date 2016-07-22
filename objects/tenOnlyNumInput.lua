-- ten only num input.lua
-- two digit number box for allowing user to select a number
-- max of leftmost digit, x, and y can be set during instanciation
-- example:
-- local numInput = require( "objects.numInput" )
-- local boxTest = numInput.new( 6, -190, 40 )
------------------------------------------------------------
local tenOnlyNumInput = {}
local widget = require( "widget" )

local leftNum = 0
local rightNum = 0
local strokeC = { 1, 0, 0.5 } --RGB, change or remove for final draft
_G.finalNumber = 0

function tenOnlyNumInput:new( leftMax, x, y ) -- constructor

    local countBox = display.newGroup()
    countBox.num = 0

    leftMax = leftMax or 9
    x = x or 0
    y = y or 0

    -- Handle number stepper events
    local function onStepperPress( event )
        local id = event.target.id

        --increments on left plus press
        if id == "LeftPlus" and leftNum < leftMax then
            leftNum = leftNum + 1
            numTxtL.text = leftNum
        end

        --increments on right plus press
        if id == "RightPlus" and rightNum < 9 then
            rightNum = rightNum + 1
            numTxtR.text = rightNum
        elseif id == "RightPlus" and rightNum == 9 then
            rightNum = 0
            numTxtR.text = rightNum
            leftNum = leftNum + 1
            numTxtL.text = leftNum
            print( rightNum )
            print( leftNum )

        end

        --increments on left plus press
        if id == "LeftMinus" and leftNum > 0 then
            leftNum = leftNum - 1
            numTxtL.text = leftNum
            print( leftNum ) -- can remove this line
        end

        --increments on right plus press
        if id == "RightMinus" and rightNum > 0 then
            rightNum = rightNum - 1
            numTxtR.text = rightNum
            print( rightNum ) -- can remove this line
        elseif id == "RightMinus" and rightNum == 0 then
            if leftNum > 0 then
                rightNum = 9
                numTxtR.text = rightNum
                leftNum = leftNum - 1
                numTxtL.text = leftNum
            end
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
    local plusButtonL = widget.newButton{
                    id = "LeftPlus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/plus.png",
                    overFile="images/plus.png", -- not needed
                    onPress = onStepperPress,
            }
        plusButtonL.x = -boxW*.25
        plusButtonL.y = -boxH*.25

--[[    local plusButtonR = widget.newButton{
                    id = "RightPlus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/plus.png",
                    overFile="images/plus.png", -- not needed
                    onPress = onStepperPress,
            }
        plusButtonR.x = boxW*.25
        plusButtonR.y = -boxH*.25
]]--

    local minusButtonL = widget.newButton{
                    id = "LeftMinus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/minus.png",
                    overFile="images/minus.png", -- not needed
                    onPress = onStepperPress,
            }
        minusButtonL.x = -boxW*.25
        minusButtonL.y = boxH*.25

 --[[   local minusButtonR = widget.newButton{
                    id = "RightMinus",
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/minus.png",
                    overFile="images/minus.png", -- not needed
                    onPress = onStepperPress,
            }
        minusButtonR.x = boxW*.25
        minusButtonR.y = boxH*.25  
]]--

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

    -- grey shadow behind left number
    local leftShadow = display.newRect (countBox, 0, 0, boxW*.45, boxH*.4)
        leftShadow:setFillColor( 0, 0, 0 )
        leftShadow.alpha = 0.5
        leftShadow.x = -boxW*.25

    -- grey shadow behind right number
    local rightShadow = display.newRect (countBox, 0, 0, boxW*.45, boxH*.4)
        rightShadow:setFillColor( 0, 0, 0 )
        rightShadow.alpha = 0.5
        rightShadow.x = boxW*.25

    countBox:insert( plusButtonL )
    --countBox:insert( plusButtonR )
    countBox:insert( minusButtonL )
    --countBox:insert( minusButtonR )
    countBox:insert( checkButton )
    countBox:insert( leftShadow )
    countBox:insert( rightShadow )

    numTxtL = display.newText( leftNum, 0, 0, default, _W*.07 )
            numTxtL:setFillColor( 0 )
            numTxtL.x = -boxW*.25
            numTxtL.y = 0

    numTxtR = display.newText( rightNum, 0, 0, default, _W*.07 )
            numTxtR:setFillColor( 0 )
            numTxtR.x = boxW*.25
            numTxtR.y = 0

    countBox:insert ( numTxtL )
    countBox:insert ( numTxtR )

    countBox.x = x
    countBox.y = y

    function countBox.getNumber()
        return leftNum * 10 + rightNum
    end

    function countBox.getCheckY()
        return checkY
    end

    function countBox.reset()
         numTxtL.text = 0
         numTxtR.text = 0
         rightNum = 0
         leftNum  = 0
        --return leftNum * 10 + rightNum
    end

    return countBox
end



return tenOnlyNumInput


