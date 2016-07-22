aClock = {}

function aClock:new(x,y, time, movable)

	local function distBetween( x1, y1, x2, y2 )
			return math.sqrt( math.pow((x2 - x1),2) + math.pow((y2 - y1),2) )
	end

	local function angleBetween( srcX, srcY, dstX, dstY )
		return ( math.deg( math.atan2( dstY-srcY, dstX-srcX ) )+90 ) % 360
	end

	local clock = display.newGroup()
	clock.x, clock.y = x,y
	clock.bgImg = display.newImage(clock,"images/clock.png", 0, 0);

	for i = 1,60 do 
		local line = display.newLine( clock, 0, 0, 0, 16 )
		line.x, line.y = 160*math.cos(math.rad( i*6) )  , 160*math.sin(math.rad(i*6)) 
		line.strokeWidth = 4
		line.alpha = .5
		line.rotation = i*6 + 90
		if i%5 == 0 then
			line:setStrokeColor(0,0,0)
		end
	end

	for i = 1,12 do 
		local line = display.newLine( clock, 0, 0, 0, 16 )
		line.x, line.y = 80*math.cos(math.rad( i*30) ), 80*math.sin(math.rad(i*30)) 
		line.strokeWidth = 4
		line.alpha = .5
		line.rotation = i*30 + 90
	end

	clock.controlPad2 = display.newCircle( clock, 0,0, 160 )
	clock.controlPad2:setFillColor(0,0,0,.01)
	clock.controlPad2.x, clock.controlPad2.y = 0, 0


	clock.controlPad = display.newCircle( clock, 0,0, 80 )
	clock.controlPad.x, clock.controlPad.y = 0,0 
	clock.controlPad:setFillColor(0,0,0,.01)
	--clock.controlPad.alpha = 0.01
	clock.controlPad:setStrokeColor(0,0,0,.2)
		clock.controlPad.strokeWidth = 8

	clock.shorthand = display.newLine(clock, 0, 0, 0, 0 - 80)
	clock.shorthand:setStrokeColor(0,0,0)
	clock.shorthand.strokeWidth = 8
	clock.shorthand.anchorX = 0

	clock.longhand = display.newLine(clock, 0, 0, 0, 0 - 160)
	clock.longhand:setStrokeColor(0,0,0)
	clock.longhand.strokeWidth = 8
	clock.longhand.anchorX = 0

	clock.shorthand.crotation = 0 
	clock.longhand.crotation = 0


	local function padTouched(self, event)

			if self.path.radius == 80 then
				clock.shorthand.rotation = angleBetween(x, y, event.x, event.y)
				clock.shorthand.crotation = angleBetween(x, y, event.x, event.y)
			end
			if self.path.radius == 160 then
				clock.longhand.rotation = angleBetween(x, y, event.x, event.y)
				clock.longhand.crotation = angleBetween(x, y, event.x, event.y)
			end

			return true
	end

	if movable == true then
	clock.controlPad2.touch = padTouched
	clock.controlPad2:addEventListener("touch", clock.controlPad2)
	--clock.controlPad:setFillColor(hlColor.R,hlColor.G,hlColor.B,.5)
	--clock.controlPad2:setFillColor(hlColor.R,hlColor.G,hlColor.B,.25)

	clock.controlPad.touch = padTouched
	clock.controlPad:addEventListener("touch", clock.controlPad)

	end

	function clock.getTime()
		if math.floor(clock.shorthand.crotation/30)   == 0 then
			return string.format( "%04d",  tostring( math.floor( clock.longhand.crotation/6)   + 12 * 100) ) 
		else	
			return string.format( "%04d",  tostring( math.floor( clock.longhand.crotation/6)   + math.floor(clock.shorthand.crotation/30) * 100) ) 
		end

	end

	function clock.setTime(time)

		local hours = time:sub(1,2)
		local mins = time:sub(3,4)
		print(tonumber( hours ) )
		print(tonumber( mins ) )
		print(tonumber( mins*6 ) )
		print(tonumber( hours*30 ) )
		clock.longhand.rotation = tonumber( mins*6 ) 
		clock.shorthand.rotation = tonumber( hours*30 ) 


	end


	return clock
end
