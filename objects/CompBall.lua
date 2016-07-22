CompBall = {}

function CompBall:new(oper,rad)
	local ball = display.newGroup()
	ball.ball = display.newCircle( 0,0, rad)
	ball.ball:setFillColor(White.R, White.G, White.B, .5)
	ball.ball.strokeWidth = _H*.01
	ball.ball:setStrokeColor(hlColor.R, hlColor.G, hlColor.B)
	ball.text = display.newText(oper, 0, 0, font, rad )
	ball.text:setFillColor(Black.R, Black.G, Black.B)
	ball.operator = oper
	return ball
end

return CompBall
