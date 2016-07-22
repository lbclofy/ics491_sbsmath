--[[ ====== G A M E  D A T A  F I L E =========
	
	 See bottom of ogt_lvelmanager.lua file for 
	 update history.
	
  Outlaw Game Tools Level Manager (OGTLM) v1.0
  Copyright 2013-2014 Three Ring Ranch
  See more at http://OutlawGameTools.com
  
  This source code may be used in both free and
  commercial projects, but the code itself may 
  not be given away or sold.
  
  In other words, sell or give away the projects
  you create with this code, as long the raw
  source of this file isn't included.

--===========================================]]

local k = {}

--[[ ==============================================================
When a level is selected OGTLM needs to send the user to another
storyboard scene. If you use the same scene for all levels (just
loading new data for each level, you'll use the k.playScene option
below. Enter the name of the storyboard scene to switch to.

If you have a different storyboard scene for each level you'll use
	the second option below as long as the scenes are named sequentially.
	For example, level1, level2, level3, etc. Or stage1, stage2, stage3, 
		etc. in that case, enter the "base name" for the scenes, such
		as level or stage. OGTLM will add the chosen level number
		to the end when the user clicks a level.
		
Or, create a table in k.sceneNames that holds the storyboard scene
name for each level you have.
	-- ==============================================================]]
k.playScene = nil --"play" -- name of SB scene or nil to go to sequential scenes
k.sequentialScene = "lessons.lesson" -- will turn into level1, level2, etc.
k.sceneNames = nil  --{"kCount_01", "addition_01", "lessons.kCount_02", "lessons.kCount_03", "lessons.kCount_04", "lessons.kCount_05"}

--[[ =========================================
 If images or audio files are in folders, define
	those here. Be sure and add a slash / to the
 end of any folder names.
	If you're not using folders, set vars to nil
--==========================================]]
k.imagePrefix = "images/"
k.audioPrefix = "audio/"

--==============================================================
-- filenames for the images used in the level manager

k.backgroundImage = nil--"background.png" -- optional, define as nil if not used
k.customLevel = nil -- get level image from function rather than next var
k.levelSquareImage = "level-round.png" -- required
k.lockImage = nil--"lock.png" -- optional, define as nil if not used
k.starImage = nil--"staryellow.png" -- optional, nil if not using stars
k.prevImage = nil--"prev-white.png" -- optional unless you need paging, define as nil if not used
k.nextImage = nil--"next-white.png" -- optional unless you need paging, define as nil if not used

--==============================================================
-- filenames for the images used in the level manager

k.selectSoundFile = nil --"levelselect.wav" -- sound when level selected, define as nil if not used
k.nextPageSoundFile = nil --"changepage.wav"-- sound when next page clicked, define as nil if not used
k.prevPageSoundFile = nil --"changepage.wav"-- sound when previous page clicked, define as nil if not used

k.audioOn = true

--==============================================================
-- the default font to be used for level number and score
k.fontName = font -- required

--==============================================================
-- info about the level number (or text) being displayed
k.showLevelNum = true
k.levelNumFontName = nil -- optional, use instead of default font for level num
k.levelNumFontSize = 56
k.levelNumFontColor = {1,1,1}
k.levelNumEmbossedFont = true
k.levelNumTextXOffset = 0 	-- horizontal offset for the level number text
k.levelNumTextYOffset = -5   -- vertical offset for the level number text
k.tileNums = nil --{"H","He","Li","Be","B","C","N","O","F","Ne","Na","Mg","Al","Si","P","S","Cl"} -- use a table of string values if desired {"A", "B", "C"}
k.showLevelNumTextWhenLocked = true

--==============================================================
-- info about the score being displayed (optional)
k.showScore = false
k.scoreFontName = nil -- optional, use instead of default font for score
k.scoreFontSize = 18
k.scoreFontColor = {1,1,1}
k.scoreEmbossedFont = true
k.scoreTextXOffset = 0 	-- horizontal offset for the score text
k.scoreTextYOffset = 0   -- vertical offset for the score text
k.scorePrefix = nil
k.scoreSuffix = " Pts"
k.showScoreWhenLocked = false

--==============================================================
-- Info about the grid itself
k.totalLevels = 11	-- total number of levels in the game. should equal (numCols * numRows) * numPages
k.numCols = 11		 -- how many columns on each page of levels
k.numRows = 1		-- how many rows on each page of levels
k.colSpace = 10 	  -- extra spacing between each column
k.rowSpace = 40 	  -- extra spacing between each row
k.gridOffsetX = 0	-- horizontal offset for the entire grid on the page
k.gridOffsetY = _H*.30 	-- vertical offset for the entire grid on the page

-- misc variables
k.numUnlocked = 15 -- how many of the first levels are unlocked (minimum 1)

k.rememberPage = true -- if true, shows page from last selected level
k.currentPage = 1 	-- probably won't change this (much) manually
k.currentLevel = 0 	-- probably won't change this (much) manually

k.swipe = false--true -- allow swiping left/right to page
k.minSwipeDistance = 20 -- number of pixels required to trigger paging

k.beforeLeaving = nil -- name of function to call after choosing level but before going there.

--==============================================================
-- star stuff
k.maxStars = 3
k.starOffsetX = 0
k.starOffsetY = -4
k.singleStarOffsetX = {0, 0, 0} -- number of elements must match k.maxStars
k.singleStarOffsetY = {0, 3, 0} -- number of elements must match k.maxStars
k.showMissingStar = false

-- next and prev arrows
k.nextOffsetX = -5 	-- tweak the positioning for the arrows here
k.nextOffsetY = 0
k.prevOffsetX = 5
k.prevOffsetY = 0

-- lock image
k.lockOffsetX = 0 	-- tweak position of the lock here
k.lockOffsetY = -5

-- storyboard effect and time for switching from level selector to chosen level.
k.sboardEffect = "crossFade"
k.sboardTime = 700

-- how fast does the level selector slide when using next/prev arrows
k.slideTime = 300 	-- milliseconds (lower number = faster slide)

k.dataFile = "ogtlm_levels"

k.userName = nil

--==============================================================
-- extra variables below that are not user-configurable.

k.displayText = nil

k.numPerPage = (k.numCols * k.numRows)
k.numPages = math.ceil ( k.totalLevels / ((k.numCols * k.numRows)) )

k.tileWidth = 100
k.tileHeight = 70

k.lockWidth = 0
k.lockHeight = 0

k.prevWidth = 0
k.prevHeight = 0

k.nextWidth = 0
k.nextHeight = 0

k.starWidth = 0 	-- will be filled in dynamically
k.starHeight = 0	-- will be filled in dynamically

k.levelInfo = {}
k.levelLocked = {}
k.starsOnLevel = {}
k.levelScores = {}

return k

--[[ =========================================

	 See bottom of ogt_lvelmanager.lua file for 
	 update history.

--==========================================]]
