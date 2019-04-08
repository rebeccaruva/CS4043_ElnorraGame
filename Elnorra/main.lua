
-----------------------------------------------------------------------------------------
--
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
--
-----------------------------------------------------------------------------------------

-- Your code here


-- TO DO LIST

-- collisions with walls
-- and ledges/drops
-- enemy types or boss?
-- animation
--set path?

-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html
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
local print = "Game Over"

local composer = require( "composer" )

-- Hide status bar
display.setStatusBar( display.HiddenStatusBar )
composer.gotoScene( "menu" )

--set up display groups
local bgGroup = display.newGroup()
local uiGroup = display.newGroup()
local charGroup = display.newGroup()
local healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )
healthBar.x = display.contentCenterX-720
healthBar.y = display.contentCenterY-535
local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)

charImage = display.newImageRect(charGroup, "Sprites/char.png", 50, 50)
charImage.x = 500
charImage.y = 500

----------------------
-----
-- health functions
-----
----------------------

local function addHealth()
  if ( healthScore < 100) then
    healthScore = healthScore +10
    display.remove( healthBar )       --to remove the previous length of the health bar
    healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )   --new length of the health bar (according to the sanity level)
    healthBar.x = display.contentCenterX-720
    healthBar.y = display.contentCenterY-535
    healthText.text = healthScore
  end
end

local function minusHealth()
  if ( healthScore >0) then
    healthScore = healthScore -10
    display.remove( healthBar )       --to remove the previous length of the health bar
    healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )   --new length of the health bar (according to the sanity level)
    healthBar.x = display.contentCenterX-720
    healthBar.y = display.contentCenterY-535
    healthText.text = healthScore
  end
  if ( healthScore ==0) then --no sanity left, game over
    display.remove( healthText ) --remove the text saying the sanity/ health level
    local printText = display.newText( print, 350, 650, native.systemFont, 200) --prints "Game Over"
    --stops the game and goes back to the menu
    --to add -------------------------------------------------------------------------------------
  end
end

----------------------
-----
-- change worlds
-----
----------------------

local function changeWorld()
  --if (backgroundBad is displayed)
    --display.remove( backgroundBad )
    --backgroundGood = display.newImageRect( "bgGood.png", size, size)
    --backgroundGood.x = display.contentCenterX
    --backgroundGood.y = display.contentCenterY
  --end
  --if (backgroundGood is displayed)
    --display.remove( backgroundGood )
    --backgroundBad = display.newImageRect( "bgBad.png", size, size)
    --backgroundBad.x = display.contentCenterX
    --backgroundBad.y = display.contentCenterY
  --end
end

-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html

----------------------
-----
-- character movement
-----
----------------------

-- direction and speed variables
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




local physics = require ("physics")
physics.start()
physics.setDrawMode("hybrid")
physics.setGravity( 0,0)
	
physics.addBody( charImage, "dynamic")
charImage.isFixedRotation = true
charImage:setLinearVelocity( 5, 0 )
	
Enemies = {}
	
function createFastEnemy( x, y )
	local newEnemy =  display.newImageRect(charGroup, "Sprites/char.png", x, y)
	physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
	newEnemy.isFixedRotation = true
	newEnemy.x = x
	newEnemy.y = y
	newEnemy.myName = "FastEnemy"
	newEnemy.speed = 30
	newEnemy.health = 50
	Enemies[#Enemies + 1] = newEnemy
end
		
function createSlowEnemy( x, y )
	local newEnemy =  display.newImageRect(charGroup, "Sprites/char.png", x, y)
	physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
	newEnemy.isFixedRotation = true
	newEnemy.x = x
	newEnemy.y = y
	newEnemy.myName = "SlowEnemy"
	newEnemy.speed = 15
	newEnemy.health = 100
	Enemies[#Enemies + 1] = newEnemy
end
Enemy1 = createFastEnemy( 400, 200 )
	--transition.to(EnemiesF[1],{ time = 4000, rotation = 90 } )  
	
function checkDirection( direction, speed )
	if math.abs(direction) > speed then
		if direction < 0 then
			return -speed
		else
			return speed
		end
	end
    return direction
end
		
	
function lookForPlayer()		
	for i = 1 , #Enemies do
		if math.abs(charImage.x - Enemies[i].x) + math.abs(charImage.y - Enemies[i].y) < 800 then 
			if math.abs(charImage.x - Enemies[i].x) < 20  then
				transition.to( Enemies[i], { x = Enemies[i].x + checkDirection(charImage.x - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 1000 }) 
			elseif math.abs(charImage.y - Enemies[i].y) < 20  then
				transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(charImage.y - Enemies[i].y , Enemies[i].speed) , time = 1000 })
			end
		end
	end
	
	timer.performWithDelay( 5000 , function() lookForPlayer() end )
end
timer.performWithDelay( 5000 , function() lookForPlayer() end )


	
function enemyCollisions( event )
	print(event.phase)
	if ( event.phase == "began" ) then
	
		local obj1 = event.object1
		local obj2 = event.object2
		print(obj1.myName)
		if( obj1.myName == "player" and obj2.myName == "FastEnemy") or
		  ( obj1.myName == "FastEnemy" and obj2.myName == "player")
		then 
			minusHealth()
				
		elseif ( obj1.myName == "player" and obj2.myName == "SlowEnemy") or
			 ( obj1.myName == "SlowEnemy" and obj2.myName == "player")
		then
			minusHealth() 
	 	end
			  	
			 --else if ( obj1.myName == "wall" and obj2.myName == "Enemy") or
			 --		 ( obj1.myName == "Enemy" and obj2.myName == "wall") 
			 --then 
			 --
			 --		
			 --
			 --else if ( obj1.myName = "boundary" and obj2.myName == "Enemy) or
			 --  	     (obj1.myName = "Enemy" and obj2.myName = "boundary")
			 --then
			 --
			 --
	end
end
	
	Runtime:addEventListener( "collision", enemyCollisions )
