AnimalBall10 = {}

function AnimalBall10:new(x,y,r,i)
    local ball = display.newGroup()
    ball.ball = display.newCircle( 0, 0, r) 
    ball.ball:setFillColor(White.R, White.G, White.B, .5) --ball fill color set to white
    -- black stroke around ball
    ball.ball.strokeWidth = _H*.01
    ball.ball:setStrokeColor(hlColor.R, hlColor.G, hlColor.B)
    -- need to change font to dyslexia
    ball.text = display.newText(i * 10 , 0, 0, font, fontSize )
    ball.text:setFillColor(Black.R, Black.G, Black.B) --text color
    ball.num = i
	return ball
end

