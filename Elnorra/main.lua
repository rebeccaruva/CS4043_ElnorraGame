-----------------------------------------------------------------------------------------
--
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
--
-----------------------------------------------------------------------------------------

-- initialize variables
local charImage
local bgImage
local healthScore = 100

local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
composer.gotoScene( "menu" )

--set up display groups
local bgGroup = display.newGroup()
local uiGroup = display.newGroup()
local charGroup = display.newGroup()
local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)

charImage = display.newImageRect(charGroup, "char.png", 250, 250)
charImage.x = 0
charImage.y = 0

if charImage.x < 100 then
  charImage.x = charImage.x + 2
end

-- function to add health
local function addHealth()
  healthScore = healthScore +10
  healthText.text = healthScore
end

-- function to deplete health
local function minusHealth()
  healthScore = healthScore -10
  healthText.text = healthScore
end

-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html