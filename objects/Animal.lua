Animal = {}

function Animal:new(file, w, h, fontsize)
	local animal = display.newGroup()
	animal.name = "animal"
	animal.ball = display.newImageRect(file, w, h)
	animal.outline = display.newCircle(0 , 0, w/2*1.15)--display.newImageRect("images/highlight.png", w, h)
	animal.outline:setFillColor(225/225,193/225,102/225)
	animal.outline.alpha = 0 
	animal.outline.rotation = math.random(360)
	animal.text = display.newText("", 0, h*.06, font, fontsize)
	animal.num = 0
	animal.matched = false
	animal:insert( animal.outline )
	animal:insert( animal.ball )
	animal:insert( animal.text )
	return animal
end
