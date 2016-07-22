local widget = require( "widget" )
dClock = {}

function dClock:new(x, y, movable, hours, mins)
	local clock = display.newGroup()
	clock.img = display.newImage(clock,"images/digi_clock.png", x, y)

	clock.nums = {}
	clock.text = {}
	clock.hours = 12
	clock.mins = 0
	clock.hourText =  display.newText(clock, string.format( "%02d", clock.hours ), x - 145, y, font, _W * .07)
	clock.minsText =  display.newText(clock, string.format( "%02d",  clock.mins), x + 145, y, font, _W * .07)

	for i=1,4 do
		if i == 1 then
			clock.nums[i] = math.floor(hours / 10)
		end
		if i == 2 then
			clock.nums[i] = hours % 10
		end
		if i == 3 then
			clock.nums[i] = math.floor(mins / 10)
		end
		if i == 4 then
			clock.nums[i] = mins % 10
		end

	end


	local function onStepperPress( event )
		local id = event.target.id
		for i=1,2 do
			if id == "plus" .. i then
					clock.nums[i] = clock.nums[i] + 1
			end
			if id == "minus" .. i then
					clock.nums[i] = clock.nums[i] - 1
			end
		end

		if clock.nums[1] > 12 then
			clock.nums[1] = 1
		elseif clock.nums[1] <= 0 then
			clock.nums[1] = 12
		end

		if clock.nums[2] == 60 then
			clock.nums[2] = 0
		elseif clock.nums[2] == -1 then
			clock.nums[2] = 59
		end
		clock.hours = clock.nums[1]
		clock.mins = clock.nums[2]
		clock.hourText.text = string.format( "%02d", clock.nums[1] ) 
		clock.minsText.text = string.format( "%02d", clock.nums[2] )
		return false
	end

	local function checkTime(h_tens, h_ones, m_tens, m_ones)
		if h_tens > 1 then
			h_tens = 1
		end
		if h_tens < 0 then
			h_tens = 0
		end
	end

	if movable == true then
		clock.plusButtons = {}
		for i=1,2 do
			clock.plusButtons[i] = widget.newButton{
                    id = "plus" .. i,
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/plus.png",
                    onPress = onStepperPress,
            }
			clock.plusButtons[i].x, clock.plusButtons[i].y = x - 145 + 2*145 * (i - 1), y - 180
			clock:insert(clock.plusButtons[i])
		end
 		clock.minusButtons = {}
		for i=1,2 do
			clock.minusButtons[i] = widget.newButton{
                    id = "minus" .. i,
                    width = _W*.07,
                    height = _W*.07,
                    defaultFile="images/minus.png",
                    onPress = onStepperPress,
            }
			clock.minusButtons[i].x, clock.minusButtons[i].y = x - 145 + 2*145 * (i - 1), y + 180
			clock:insert(clock.minusButtons[i])
		end
	end

	function clock.setTime( time )
		
		clock.hourText.text = time:sub( 1,2 )
		clock.minsText.text = time:sub( 3,4 )
		clock.hours = tonumber( time:sub( 1,2 ) ) 
		clock.mins = tonumber( time:sub( 3,4 ) )
		clock.nums[1] = clock.hours
		clock.nums[2] =  clock.mins
        
    end

    function clock.getTime()
    	print(string.format( "GET TIME: %04d",  tostring(  clock.mins   + clock.hours *100 ) ) )
		return string.format( "%04d",  tostring(  clock.mins   + clock.hours *100 ) ) 
        
    end

	return clock
end
