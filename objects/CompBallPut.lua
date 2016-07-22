CompBallPut = {}

function CompBallPut:new(rad)
	local ball = display.newGroup()
	ball.ball = display.newCircle(0,0, rad)
	ball.ball:setFillColor(Blue.R, Blue.G, Blue.B, .5)
	ball.ball.strokeWidth = _H*.01
	ball.ball:setStrokeColor(hlColor.R, hlColor.G, hlColor.B)
	ball.text = display.newText("", 0, 0, font, rad)
	ball.text:setFillColor(Black.R, Black.G, Black.B)
	ball.operator = ""
	return ball
end

return CompBallPut
