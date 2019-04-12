local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function goToMenu()
 composer.gotoScene( "menu")
end

-- initialize variables
local charImage
local bgImage
local healthScore = 100
local gameOver = "Game Over"
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

    local sceneGroup = self.view
    -- Code here runs when the scene is first created but has not yet appeared on screen

end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is still off screen (but is about to come on screen)

        local backButton = display.newImage(sceneGroup, "Left-Arrow.png" )
    		backButton.x = display.contentCenterX - 950
    		backButton.y = display.contentHeight - 1150

        local menu_tap_to_play = display.newText(sceneGroup, "INSERT GAME", display.contentCenterX, display.contentHeight - 600, "Arial", 200)

        backButton:addEventListener( "tap", goToMenu )
        
         -- Set up display groups

        local backGroup = display.newGroup()  -- Display group for the background image
        local charGroup = display.newGroup()  -- Display group for the hero, ennemys, weapon held, etc.
        local uiGroup = display.newGroup()
        
        --initialize variables
        local healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )
        healthBar.x = display.contentCenterX-720
        healthBar.y = display.contentCenterY-535
        local healthText = display.newText( sceneGroup,  healthScore, -200, 100, native.systemFont, 60)
        
        local physics = require ("physics")
        physics.start()
        physics.setDrawMode("hybrid")
        physics.setGravity( 0,0)
        
        charImage = display.newImageRect(sceneGroup, "Sprites/char.png", 70, 100)
        charImage.x = 500
        charImage.y = 500
        physics.addBody( charImage, "dynamic")
        charImage.isFixedRotation = true
        charImage.myName = "player"
        
        xA = charImage.x
        yA = charImage.y
        
  		function attackSense() 
  			display.remove(attackSensor)
  			attackSensor = display.newImageRect(sceneGroup, "Sprites/char.png", 85, 115 )
  			physics.addBody(attackSensor, "static" ,{isSensor=true})
  			attackSensor.isVisible = false
  			if dir == 8 then 
	  			attackSensor.x = charImage.x
	  			attackSensor.y = charImage.y - 50
	  			xA = charImage.x
	  			yA = charImage.y - 50
	  		elseif dir == 6 then
	  			attackSensor.x = charImage.x + 50
	  			attackSensor.y = charImage.y
	  			xA = charImage.x + 50
	  			yA = charImage.y
	  		elseif dir == 4 then
	  			attackSensor.x = charImage.x - 50
	  			attackSensor.y = charImage.y
	  			xA = charImage.x - 50
	  			yA = charImage.y
	  		elseif dir == 2 then
	  			attackSensor.x = charImage.x
	  			attackSensor.y = charImage.y + 50
	  			xA = charImage.x
	  			yA = charImage.y + 50
	  		else
	  			attackSensor.x = xA
	  			attackSensor.y = yA
	  		end
	        attackSensor.myName = "weapon"
	        attackSensor.isFixedRotation = true
  		end
 
Runtime:addEventListener("enterFrame",  attackSense )
  		
Enemies = {}

attack = false

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

        -- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
        -- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html

        ----------------------
        -----
        -- character movement
        -----
        ----------------------
        -- direction ad speed variables
        dir = 0 --n8 is up, 4 is left, 2 is down, 6 is right ( like numpad )
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
            attack = false
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
          if (event.keyName == "c") then
		    if(buttonPressed == true) then
		    	attack = true
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
		
		-- createEnemy
		-- patrol can be set to square, linex or liney
		-- pathx is x distance of patrol
		-- pathy is y distance of patrol
		-- path counter sets what point to start patrol at
		-- if patrol is set it sets which corner to start the square or the line from
		-- if follow equals true then ai follows player or it will keep to the path it is given

		function createEnemy( x, y, speed, health, damage, follow, patrol, pathx, pathy, pathCounter )
			local newEnemy =  display.newImageRect(sceneGroup, "Sprites/char.png", 50, 50)
			physics.addBody( newEnemy, "dynamic",{ density = 1000 ,bounce = 0})
			newEnemy.isFixedRotation = true
			newEnemy.x = x
			newEnemy.y = y
			newEnemy.myName = "Enemy"
			newEnemy.speed = speed
			newEnemy.health = health
			newEnemy.damage = damage
			newEnemy.follow = follow
			newEnemy.patrol = patrol
			newEnemy.pathCounter = pathCounter
			newEnemy.startx = x
			newEnemy.starty = y
			newEnemy.pathx = pathx
			newEnemy.pathy = pathy
			Enemies[#Enemies + 1] = newEnemy
		end
		
		createEnemy( 200, 200, 20, 50, 50, true, "square", 50, 50, 1)
----------------------------
-------
--	Enemy pathSet and Follow
-------
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
		
		function setPath(i)
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
		
		function lookForPlayer()		
			for i = 1 , #Enemies do
				if math.abs(charImage.x - Enemies[i].x) + math.abs(charImage.y - Enemies[i].y) < 800 and Enemies[i].follow == true then 
					if math.abs(charImage.x - Enemies[i].x) > 20  then
						transition.to( Enemies[i], { x = Enemies[i].x + checkDirection(charImage.x - Enemies[i].x , Enemies[i].speed) , y = Enemies[i].y , time = 250 }) 
					elseif math.abs(charImage.y - Enemies[i].y) > 20  then
						transition.to( Enemies[i], { x = Enemies[i].x , y = Enemies[i].y + checkDirection(charImage.y - Enemies[i].y , Enemies[i].speed) , time = 250 })
					end
					
				else
					setPath(i)
				end
			end
			
			timer.performWithDelay( 250 , function() lookForPlayer() end )
		end
		timer.performWithDelay( 3000 , function() lookForPlayer() end )
		
		function knockback( self, other, knockbackAmt )
			transition.cancel(other)
			if other.x < self.x then
				if other.y < self.y then
					transition.to( self, {time=250,x=self.x + knockbackAmt, y=self.y + knockbackAmt})
				elseif other.y > self.y then
					transition.to( self, {time=250,x=self.x + knockbackAmt, y=self.y - knockbackAmt})
				end
			elseif other.x > self.x then
				if other.y < self.y then
					transition.to( self, {time=250,x=self.x - knockbackAmt, y=self.y + knockbackAmt})
				elseif other.y > self.y then
					transition.to( self, {time=250,x=self.x - knockbackAmt, y=self.y - knockbackAmt})
				end
			else
				if other.y < self.y then
					transition.to( self, {time=250,x=self.x, y=self.y + knockbackAmt})
				elseif other.y > self.y then
					transition.to( self, {time=250,x=self.x, y=self.y - knockbackAmt})
				end
			end
		end
		
		--basic collision function
			
		function enemyCollisions( event )
			if ( event.phase == "began" ) then
			
				local obj1 = event.object1
				local obj2 = event.object2
				if( obj1.myName == "player" and obj2.myName == "Enemy") then
					minusHealth(obj2.damage)
					transition.cancel(obj2)
					knockback( obj1, obj2, 80)
				elseif ( obj1.myName == "player" and obj2.myName == "hero") then
					minusHealth(obj1.damage)
					transition.cancel(obj1)
					knockback( obj2, obj1, 80)
				
				elseif (obj1.myName == "weapon" and obj2.myName == "Enemy") then
					if attack == true then
					    if obj1.health <= 0 then
					    	display.remove(obj2)
					    else
					    	timer.performWithDelay(1500, function() obj2.health = obj2.health - 25 end )
					    	transition.cancel(obj2)
					    	knockback( ob2, obj1, 40)
					  	end
					end
					attack = false
				elseif( obj1.myName == "Enemy" and obj2.myName == "weapon" ) then
					if attack == true then
						timer.performWithDelay(1500, function() obj1.health = obj1.health - 25 end )
						 if obj1.health <= 0 then 
						 	display.remove(obj1) 
						 else
						 	timer.performWithDelay(1500, function() obj1.health = obj1.health - 25 end )
						 	transition.cancel(obj1)
						 	knockback( obj1, obj2, 40)
						 end
					end
					attack = false
				end
			end
		end
			
		Runtime:addEventListener( "collision", enemyCollisions )
		
		
		
		

    elseif ( phase == "did" ) then
        -- Code here runs when the scene is entirely on screen

    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)

    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
