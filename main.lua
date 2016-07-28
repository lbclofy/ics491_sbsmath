--require "CiderDebugger";---------------------------------------------------------------------------------
--
-- main.lua
--
---------------------------------------------------------------------------------

--local performance = require('objects.performance') -- CAN COMMENT OUT IF NOT TESTING
--performance:newPerformanceMeter() -- CAN COMMENT OUT IF NOT TESTING

-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

---------------------------------------------------------------------------------
-------------- GLOBAL VARIABLES -------------- 
---------------------------------------------------------------------------------

_G._W = display.contentWidth
_G._H = display.contentHeight
_G.centerX = _W*.5
_G.centerY = _H*.5

_G.scale = _H/960
_G.width = 100*scale
_G.ballR = width*.375

_G.maxSpeed  = _W

_G.font = "Dyslexie Regular"
_G.fontText = native.newFont( "Dyslexie Regular" , _H*.06)

--Colors    { R = ,   G = ,     B = }
_G.Red =      { R = 244/255,  G = 060/255,  B = 039/255 }
_G.Red100 =   { R = 255/255,  G = 205/255,  B = 210/255 }
_G.Red300 =   { R = 229/255,  G = 115/255,  B = 115/255 }
_G.Red700 =   { R = 211/255,  G = 047/255,  B = 047/255 }
_G.Yellow =   { R = 225/255,  G = 196/255,  B = 000/255 }
_G.Green =    { R = 000/255,  G = 148/255,  B = 076/255 }
_G.Blue =     { R = 000/255,  G = 191/255,  B = 165/255 }--{ R = 033/255,  G = 150/255,  B = 243/255 }
_G.Blue100 =  { R = 187/255,  G = 222/255,  B = 251/255 }
_G.Blue300 =  { R = 100/255,  G = 181/255,  B = 246/255 }
_G.Blue700 =  { R = 025/255,  G = 118/255,  B = 210/255 }
_G.Purple =   { R = 156/255,  G = 039/255,  B = 176/255 }
_G.BlueGrey = { R = 096/255,  G = 125/255,  B = 139/255 }
_G.Black =    { R = 000/255,  G = 000/255,  B = 000/255 }
_G.White =    { R = 255/255,  G = 255/255,  B = 255/255 }
_G.hlColor =  { R = 244/255,  G = 067/255,  B = 054/255 }
_G.priColor = { R = Yellow.R, G = Yellow.G, B = Yellow.B}
_G.secColor = { R =  Blue.R,  G = Blue.G,   B = Blue.B  }

_G.outlineColor = { highlight = { r= 0, g=0, b=0 }, shadow = { r=0, g=0, b=0 } }


_G.fontSize = _W*.05
_G.phi = 1.618033988749894


_G.gRadius = { 1.000*ballR, 2.000*ballR, 2.155*ballR, 2.415*ballR, 2.702*ballR, 3.001*ballR, 3.001*ballR, 3.305*ballR, 3.614*ballR, 3.924*ballR, 4.000*ballR, 4.155*ballR}

_G.bg = display.newRect(centerX, centerY, _W, _H)
bg:setFillColor( 34/255, 31/255, 31/255)


---------------------------------------------------------------------------------
-------------- GLOBAL FUNCTIONS -------------- 
---------------------------------------------------------------------------------

-------------- TRANSITIONS OBJECTS BETWEEN COLORS 
-------------- PARAMS: 
-------------- obj: the object to change colors
-------------- colorFrom: the current color of the object
-------------- colorTo: the color the object will become
-------------- time: the time in milliseconds
-------------- delay: the delay in milliseconds
-------------- ease: https://docs.coronalabs.com/daily/api/library/easing/index.html
---------------------------------------------------------------------------------
transition.callback = transition.to ;
function transition.fromtocolor(obj, colorFrom, colorTo, time, delay, ease)

        local _obj =  obj ;
        local ease = ease or easing.linear


        local fcolor = colorFrom or {255,255,255} ; -- defaults to white
        local tcolor = colorTo or {0,0,0} ; -- defaults to black
        local t = nil ;
        local p = {} --hold parameters here
        local rDiff = tcolor[1] - fcolor[1] ; --Calculate difference between values
        local gDiff = tcolor[2] - fcolor[2] ;
        local bDiff = tcolor[3] - fcolor[3] ;

                --Set up proxy
        local proxy = {step = 0} ;

    local mt

    if( obj and obj.setTextColor ) then
      mt = {
          __index = function(t,k)
              --print("get") ;
              return t["step"]
          end,

          __newindex = function (t,k,v)
              --print("set")
              --print(t,k,v)
              if(_obj.setTextColor) then
                  _obj:setTextColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff) )
              end
              t["step"] = v ;


          end

      }
    else
       mt = {
          __index = function(t,k)
              --print("get") ;
              return t["step"]
          end,

          __newindex = function (t,k,v)
              --print("set")
              --print(t,k,v)
              if(_obj.setFillColor) then
                  _obj:setFillColor(fcolor[1] + (v*rDiff) ,fcolor[2] + (v*gDiff) ,fcolor[3] + (v*bDiff) )
              end
              t["step"] = v ;


          end

      }
    end

        p.time = time or 1000 ; --defaults to 1 second
        p.delay = delay or 0 ;
        p.transition = ease ;


        setmetatable(proxy,mt) ;

        p.colorScale = 1 ;

        t = transition.to(proxy,p , 1 )  ;

        return t

end

-------------- MOVES OBJECTS ACCORDING TO MATERIAL DESIGN PRINCIPLES
-------------- PARAMS: 
-------------- obj: the object to be moved
-------------- xt: the target x coord
-------------- yt: the target y coord
-------------- time: the time in milliseconds
-------------- delay: the delay in milliseconds
---------------------------------------------------------------------------------
transition.callback = transition.to ;
function transition.matTrans(obj, xt, yt, time, delay )

  local delay = delay or 0

  local function endMove ( obj )
    transition.to( obj, { time=250, xScale = 1.0, yScale = 1.0 } )
  end

  local function move ( obj )
    transition.to( obj, {x = xt, y = yt, onComplete = endMove, easing = easing.inOutCubic, time = time } )
  end

  transition.to( obj, { time=250, xScale = 1.1, yScale = 1.1, onComplete=move } )

end

-------------- TAKES IN DECIMAL AND RETURNS STRING VERSION
-------------- PARAMS: 
-------------- number: the decimal version to be converted
---------------------------------------------------------------------------------
local function convertDecToLat( number )

    local text = "zero"

    if     number == 1 then text = "One"
    elseif number == 2 then text = "Two"
    elseif number == 3 then text = "Three"
    elseif number == 4 then text = "Four"
    elseif number == 5 then text = "Five"
    elseif number == 6 then text = "Six"
    elseif number == 7 then text = "Seven"
    elseif number == 8 then text = "Eight"
    elseif number == 9 then text = "Nine"
    elseif number == 10 then text = "Ten"
    elseif number == 11 then text = "Eleven"
    elseif number == 12 then text = "Twelve"
    elseif number == 13 then text = "Thirteen"
    elseif number == 14 then text = "Fourteen"
    elseif number == 15 then text = "Fifteen"
    elseif number == 16 then text = "Sixteen"
    elseif number == 17 then text = "Seventeen"
    elseif number == 18 then text = "Eighteen"
    elseif number == 19 then text = "Nineteen"
    elseif number == 20 then text = "Twenty"
    elseif number == 30 then text = "Thirty"
    elseif number == 40 then text = "Forty"
    elseif number == 50 then text = "Fifty"
    elseif number == 60 then text = "Sixty"
    elseif number == 70 then text = "Seventy"
    elseif number == 80 then text = "Eighty"
    elseif number == 90 then text = "Ninety"
    elseif number == 100 then text = "One Hundred"
    elseif number == 110 then text = "One Hundred Ten"
    elseif number == 120 then text = "One Hundred Twenty"
    elseif number == 130 then text = "One Hundred Thirty"
    elseif number == 140 then text = "One Hundred Forty"
    elseif number == 150 then text = "One Hundred Fifty"
    elseif number == 160 then text = "One Hundred Sixty"
    elseif number == 170 then text = "One Hundred Seventy"
    elseif number == 180 then text = "One Hundred Eighty"
    elseif number == 190 then text = "One Hundred Ninety"
    elseif number == 200 then text = "Two Hundred"
    elseif number == 0 then text = "Zero"
    else                    text = " "
    end

    return text

end
_G.convertDecToLat = convertDecToLat

-------------- TAKES IN DECIMAL AND RETURNS STRING VERSION
-------------- PARAMS: 
-------------- w: the width of the grid to be created 
-------------- h: the height of the grid to be created
-------------- size: the number of grid spaces
---------------------------------------------------------------------------------
local function createGrid(w, h, size)
	local p = Math.floor(w / size)
	local q = Math.floor(h / size)
	retval = {}
	for i=1,p do
		retval[i] = {}
		for j=1,q do
			retval[i][j] = false
		end
	end
end
_G.createGrid = createGrid


-------------- Composer controls screen transitions necessary to move between different
-------------- scenes and levels. 
local composer = require( "composer" )
composer.recycleOnSceneChange = true

-------------- Moves to menu screen 
composer.gotoScene( "loginPage" )

--composer.gotoScene( "lessons.kCount_01" )
--composer.gotoScene( "lessons.kCount_02" )
--composer.gotoScene( "lessons.kCount_02_2" )
--composer.gotoScene( "lessons.kCount_03" )
--composer.gotoScene( "lessons.intro1" )
--composer.gotoScene( "lessons.lesson1" )
--composer.gotoScene( "lessons.lesson2" )
--composer.gotoScene( "lessons.lesson3" )
--composer.gotoScene( "lessons.lesson4" )
--composer.gotoScene( "lessons.lesson5" )
--composer.gotoScene( "lessons.lesson6" )
--composer.gotoScene( "lessons.lesson7" )
--composer.gotoScene( "lessons.lesson8" )
--composer.gotoScene( "lessons.lesson9" )
--composer.gotoScene( "lessons.lesson11" )
--composer.gotoScene( "lessons.lesson12" )
--composer.gotoScene( "lessons.lesson13" )
