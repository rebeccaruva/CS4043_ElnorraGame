
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
local gameOver = "Game Over"

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

local function minusHealth( damage )
  if ( healthScore >0) then
    healthScore = healthScore - damage
    display.remove( healthBar )       --to remove the previous length of the health bar
    healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )   --new length of the health bar (according to the sanity level)
    healthBar.x = display.contentCenterX-720
    healthBar.y = display.contentCenterY-535
    healthText.text = healthScore
  end
  if ( healthScore <= 0) then --no sanity left, game over
    display.remove( healthText ) --remove the text saying the sanity/ health level
    local printText = display.newText( gameOver, 350, 650, native.systemFont, 200) --prints "Game Over"
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
    charImage.y = charImage.y - 4
  elseif(dir == 4) then
    charImage.x = charImage.x - 4
  elseif (dir == 2) then
    charImage.y = charImage.y + 4
  elseif(dir == 6) then
    charImage.x = charImage.x + 4
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


--------------------------
-----
--	Enemy creation
-----
--------------------------

local physics = require ("physics")
physics.start()
physics.setDrawMode("hybrid")
physics.setGravity( 0,0)
	
physics.addBody( charImage, "dynamic")
charImage.isFixedRotation = true
charImage.myName = "player"
	
Enemies = {}

-- createEnemy
-- patrol can be set to square, linex or liney
-- pathx is x distance of patrol
-- pathy is y distance of patrol
-- path counter sets what point to start patrol at
-- if patrol is set it sets which corner to start the square or the line from
	
function createEnemy( x, y, speed, health, damage, patrol, pathx, pathy, pathCounter )
	local newEnemy =  display.newImageRect(charGroup, "Sprites/char.png", 50, 50)
	physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
	newEnemy.isFixedRotation = true
	newEnemy.x = x
	newEnemy.y = y
	newEnemy.myName = "Enemy"
	newEnemy.speed = speed
	newEnemy.health = health
	newEnemy.damage = damage
	newEnemy.patrol = patrol
	newEnemy.pathCounter = pathCounter
	newEnemy.startx = x
	newEnemy.starty = y
	newEnemy.pathx = pathx
	newEnemy.pathy = pathy
	Enemies[#Enemies + 1] = newEnemy
end

createEnemy( 200, 200, 20, 50, 50, "liney", 50, 50, 1)
	
----------------------------
-----
--	Enemy pathSet and Follow
-----
----------------------------
	
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
		
--lookForPlayer checks player distance and if it is within a set amount then enemy moves toward player in x direction then y
--else it can follow a set path if we set one
-- also if player gets out of range the enemy will return to its path

function lookForPlayer()		
	for i = 1 , #Enemies do
		if math.abs(charImage.x - Enemies[i].x) + math.abs(charImage.y - Enemies[i].y) < 800 then 
			if math.abs(charImage.x - Enemies[i].x) > 20  then
				transition.to( Enemies[i], { x = Enemies[i].x + checkDirection(charImage.x - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
			elseif math.abs(charImage.y - Enemies[i].y) > 20  then
				transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(charImage.y - Enemies[i].y , Enemies[i].speed) , time = 250 })
			end
			
		else
			if Enemies[i].patrol == "square" then
				if Enemies[i].pathCounter == 1 then
					if math.abs(Enemies[i].startx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 2
					end
				elseif Enemies[i].pathCounter == 2 then
					if math.abs(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 3
					end
				
				elseif Enemies[i].pathCounter == 3 then
					if math.abs(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 4
					end
				else
					if math.abs(Enemies[i].startx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 1
					end
				end
			elseif Enemies[i].patrol == "linex" then
				if Enemies[i].pathCounter == 1 then
					if math.abs(Enemies[i].startx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 2
					end
				else
					if math.abs(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx + Enemies[i].pathx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 1
					end
				end
			elseif Enemies[i].patrol == "liney" then
				if Enemies[i].pathCounter == 1 then
					if math.abs(Enemies[i].startx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 2
					end
				else
					if math.abs(Enemies[i].startx - Enemies[i].x) > 0  then
						transition.to( Enemies[i],{ x = Enemies[i].x + checkDirection(Enemies[i].startx - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y) > 0  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(Enemies[i].starty + Enemies[i].pathy - Enemies[i].y , Enemies[i].speed) , time = 250 })
					else
						Enemies[i].pathCounter = 1
					end
				end
			end
		end
	end
	
	timer.performWithDelay( 250 , function() lookForPlayer() end )
end

timer.performWithDelay( 3000 , function() lookForPlayer() end )

--basic collision function
	
function enemyCollisions( event )
	if ( event.phase == "began" ) then
	
		local obj1 = event.object1
		local obj2 = event.object2
		if( obj1.myName == "player" and obj2.myName == "Enemy") then
			minusHealth(obj2.damage)
		elseif ( obj1.myName == "Enemy" and obj2.myName == "player") then
			minusHealth(obj1.damage)
		end
	end
end
	
	Runtime:addEventListener( "collision", enemyCollisions )
