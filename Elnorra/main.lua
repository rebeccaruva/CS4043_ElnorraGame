-----------------------------------------------------------------------------------------
--
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
--
-----------------------------------------------------------------------------------------

-- Your code here

-- initialize variables
local charImage
local bgImage

--set up display groups
local bgGroup = display.newGroup()
local uiGroup = display.newGroup()
local charGroup = display.newGroup()

charImage = display.newImageRect(charGroup, "Sprites/char.png", 250, 250)
charImage.x = 0
charImage.y = 0

if charImage.x < 100 then
  charImage.x = charImage.x + 2
end


-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html
