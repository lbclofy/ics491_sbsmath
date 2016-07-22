TenNumLine = {}

--:new( minumum number, max number, total length of line, angle of line )

function TenNumLine:new( min, max, length, angle, textSize )
    
  local size
  if textSize == nil then
    size = fontSize
  else
    size = textSize
  end

  local line = display.newGroup()
  local range = max - min
  local anglePerp = math.rad(angle) + 1.57079633
  local hashW = fontSize*.25
  local step =  length/range

	line.iMin = min;
	line.iMax = max;
  line.line = display.newLine( line, 0, 0, length, 0 )
  line.line.rotation = angle
  line.line.strokeWidth = _H*.01
  line.line:setStrokeColor(0,0,0)

  line:insert(line.line)

  line.num = {}
  line.hash = {}

  for i=min,max do
    line.num[i] = display.newText( i*10 , step*(i - min)*math.cos(math.rad(angle)) - 3*hashW*math.cos(anglePerp),
                step*(i-min)*math.sin(math.rad(angle) ) - 3*hashW*math.sin(anglePerp), font, size  )
    line.num[i]:setFillColor( priColor.R,priColor.G,priColor.B )
    line.hash[i] = display.newLine(   step*(i -min)*math.cos(math.rad(angle)) - hashW*math.cos(anglePerp), step*(i - min)*math.sin(math.rad(angle)) - hashW*math.sin(anglePerp),
               step*(i-min)*math.cos(math.rad(angle)) + hashW*math.cos(anglePerp), step*(i - min)*math.sin(math.rad(angle)) + hashW*math.sin(anglePerp)    )
    line.hash[i].strokeWidth = _H*.01
    line.hash[i]:setStrokeColor(0,0,0)


    line:insert( line.hash[i] )
    line:insert( line.num[i] )

  end

  --


  return line
end


return TenNumLine


