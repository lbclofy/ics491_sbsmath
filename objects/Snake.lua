Snake = {}

function Snake:new(length)
	local snake = display.newGroup()
	snake.img = display.newImageRect("images/snake_" .. length ..  ".png", 6 * _W * .075 * .5, 4 * _H * .075 * .5)
	snake.whichBucket = ""
	snake:rotate(-90)
	snake:insert(snake.img)

local function drag( event )
	local t = event.target
	
	local phase = event.phase
	if "began" == phase then
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y

	elseif t.isFocus then
		if "moved" == phase then
			t.x = event.x - t.x0
			t.y = event.y - t.y0

		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
		end
	end

	return true
end

	snake:addEventListener("touch", drag)



	return snake
end
