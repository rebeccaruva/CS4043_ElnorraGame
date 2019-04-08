-----------------------------------------------------------------------------------------
------
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
------
-----------------------------------------------------------------------------------------

-- initialize variables
local charImage
local bgImage
local healthScore = 100

--set up display groups
local bgGroup = display.newGroup()
local uiGroup = display.newGroup()
local charGroup = display.newGroup()
local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)

charImage = display.newImageRect(charGroup, "Sprites/char.png", 50, 50)
charImage.x = 500
charImage.y = 500

local function addHealth()
  healthScore = healthScore +10
  healthText.text = healthScore
end

local function minusHealth()
  healthScore = healthScore -10
  healthText.text = healthScore
end

-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html

----------------------
-----
-- character movement
-----
----------------------
-- direction ad speed variables
local dir = 0 --n8 is up, 4 is left, 2 is down, 6 is right ( like numpad )
local speed = 2 -- can be changed in other parts of code if needed

-- every frame move (or dont move) the character depending on dir
local function moveChar()
  if(dir == 8) then
    charImage.y = charImage.y - 1
  elseif(dir == 4) then
    charImage.x = charImage.x - 1
  elseif (dir == 2) then
    charImage.y = charImage.y + 1
  elseif(dir == 6) then
    charImage.x = charImage.x + 1
  end
end

-- run every fps interval
Runtime:addEventListener( "enterFrame", moveChar)

-- on key inputs do whats in this function
local function onKeyEvent(event)
  -- check if button is pressed in general
  if (event.phase == "down") then
    buttonPressed = true;
  elseif (event.phase == "up") then
    buttonPressed = false;
  end

  -- if no buttons are pressed then stop moving
  if(buttonPressed == false) then
    dir = 0
  end

  -- each button move the player either up/down or left/right
  if((event.keyName == "w") or (event.keyName == "up")) then
    if(buttonPressed == true) then
      dir = 8
    end
  elseif((event.keyName == "a") or (event.keyName == "left")) then
    if(buttonPressed == true) then
      dir = 4
    end
  elseif ((event.keyName == "s") or (event.keyName == "down")) then
    if(buttonPressed == true) then
      dir = 2
    end
  elseif ((event.keyName == "d") or (event.keyName == "right")) then
    if(buttonPressed == true) then
      dir = 6
    end
  end
end

-- listen for key input from user
Runtime:addEventListener( "key", onKeyEvent)