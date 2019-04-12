-----------------------------------------------------------------------------------------
------
-- main.lua
-- code by Bex, Cecile, Maxime, Sarah, and Darragh
------
-----------------------------------------------------------------------------------------


-- TO DO LIST

-- collisions with walls
-- and ledges/drops
-- enemy types or boss?
-- animation
--set path?

-- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
-- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html

local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function goToMenu()
 composer.gotoScene( "menu")
end


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

        -- initialize variables
        local charImage
        local bgImage
        local healthScore = 100
        local gameOver = "Game Over"
        local canCollect = false;
        local itemCount = 0;
        local itemsLeft = true

        local composer = require( "composer" )

        local physics = require ("physics")
        physics.start()
        physics.setDrawMode("hybrid")
        physics.setGravity( 0,0)

        -- Set up display groups
        local backGroup = display.newGroup()  -- Display group for the background image
        local charGroup = display.newGroup()  -- Display group for the hero, ennemys, weapon held, etc.
        local uiGroup = display.newGroup()

        local healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )
        healthBar.x = display.contentCenterX-720
        healthBar.y = display.contentCenterY-535
        local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)
        
        --load the filter
        local filter = display.newImageRect(uiGroup, "filter.png", 1280*2, 720*2)
        filter.x = display.contentCenterX
        filter.y = display.contentCenterY
        filter.alpha = 0

        -- show item to collect
        local item1 = display.newImageRect(uiGroup, "item.png", 175, 175)
        item1.x = 750
        item1.y = 400
        item1.alpha = 0

        charImage = display.newImageRect(charGroup, "Sprites/charSprite.png", 50, 50)
        charImage.x = 500
        charImage.y = 500
        physics.addBody( charImage, "dynamic")
        charImage.isFixedRotation = true
        charImage.myName = "player"

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
        -- Load the background
        --

        --------------------------
        -----
        --	Enemy creation
        -----
        --------------------------
        Enemies = {}

        -- createEnemy
        -- patrol can be set to square, linex or liney
        -- pathx is x distance of patrol
        -- pathy is y distance of patrol
        -- path counter sets what point to start patrol at
        -- if patrol is set it sets which corner to start the square or the line from

        function createEnemy( x, y, speed, health, damage, follow, patrol, pathx, pathy, pathCounter )
          local newEnemy =  display.newImageRect(charGroup, "Sprites/boo.png", 50, 50)
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
          return newEnemy
        end

        --createEnemy( 200, 200, 20, 50, 50, "liney", 50, 50, 1)

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
            if math.abs(charImage.x - Enemies[i].x) + math.abs(charImage.y - Enemies[i].y) < 800 and Enemies[i].follow then
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


        local roomList = {}
        roomList.wallList = {}
        roomList.doorList = {}
        roomList.enemyList = {}

        roomList.wallList[1] = {}
        roomList.wallList[1][1] = {}
        roomList.wallList[1][1].x = 405
        roomList.wallList[1][1].y = 350
        roomList.wallList[1][1].width = 14
        roomList.wallList[1][1].height = 700

        roomList.wallList[1][2] = {}
        roomList.wallList[1][2].x = 890
        roomList.wallList[1][2].y = 350
        roomList.wallList[1][2].width = 14
        roomList.wallList[1][2].height = 700

        roomList.wallList[1][3] = {}
        roomList.wallList[1][3].x = 650
        roomList.wallList[1][3].y = 135
        roomList.wallList[1][3].width = 500
        roomList.wallList[1][3].height = 14

        roomList.wallList[1][4] = {}
        roomList.wallList[1][4].x = 495
        roomList.wallList[1][4].y = 717
        roomList.wallList[1][4].width = 200
        roomList.wallList[1][4].height = 100

        roomList.wallList[1][5] = {}
        roomList.wallList[1][5].x = 797
        roomList.wallList[1][5].y = 717
        roomList.wallList[1][5].width = 200
        roomList.wallList[1][5].height = 100

        roomList.wallList[2] = {}
        roomList.wallList[2][1] = {}
        roomList.wallList[2][1].x = 268
        roomList.wallList[2][1].y = 325
        roomList.wallList[2][1].width = 70
        roomList.wallList[2][1].height = 425

        roomList.wallList[2][2] = {}
        roomList.wallList[2][2].x = 1112
        roomList.wallList[2][2].y = 475
        roomList.wallList[2][2].width = 14
        roomList.wallList[2][2].height = 790

        roomList.wallList[2][3] = {}
        roomList.wallList[2][3].x = 473
        roomList.wallList[2][3].y = 220
        roomList.wallList[2][3].width = 365
        roomList.wallList[2][3].height = 14

        roomList.wallList[2][4] = {}
        roomList.wallList[2][4].x = 547
        roomList.wallList[2][4].y = 937
        roomList.wallList[2][4].width = 550
        roomList.wallList[2][4].height = 120

        roomList.wallList[2][5] = {}
        roomList.wallList[2][5].x = 1025
        roomList.wallList[2][5].y = 937
        roomList.wallList[2][5].width = 200
        roomList.wallList[2][5].height = 120

        roomList.wallList[2][6] = {}
        roomList.wallList[2][6].x = 940
        roomList.wallList[2][6].y = 220
        roomList.wallList[2][6].width = 365
        roomList.wallList[2][6].height = 14

        roomList.wallList[2][7] = {}
        roomList.wallList[2][7].x = 268
        roomList.wallList[2][7].y = 820
        roomList.wallList[2][7].width = 70
        roomList.wallList[2][7].height = 350

        roomList.doorList = {}
        roomList.doorList[1] = {}
        roomList.doorList[1][1] = {}
        roomList.doorList[1][1].x = 645
        roomList.doorList[1][1].y = 735
        roomList.doorList[1][1].width = 90
        roomList.doorList[1][1].height = 60
        roomList.doorList[1][1].teleportTo = 2
        roomList.doorList[1][1].playerX = 500
        roomList.doorList[1][1].playerY = 450

        roomList.doorList[2] = {}
        roomList.doorList[2][1] = {}
        roomList.doorList[2][1].x = 750
        roomList.doorList[2][1].y = 900
        roomList.doorList[2][1].width = 90
        roomList.doorList[2][1].height = 60
        roomList.doorList[2][1].teleportTo = 1
        roomList.doorList[2][1].playerX = 500
        roomList.doorList[2][1].playerY = 400

        roomList.enemyList[1] = {}
        roomList.enemyList[1][1] = {}
        roomList.enemyList[1][1].x = 500
        roomList.enemyList[1][1].y = 600
        roomList.enemyList[1][1].speed = 10
        roomList.enemyList[1][1].health = 4
        roomList.enemyList[1][1].damage = 5
        roomList.enemyList[1][1].follow = true
        roomList.enemyList[1][1].patrol = "square"
        roomList.enemyList[1][1].pathx = 40
        roomList.enemyList[1][1].pathy = 60
        roomList.enemyList[1][1].pathCounter = 1

        roomList.enemyList[1][2] = {}
        roomList.enemyList[1][2].x = 900
        roomList.enemyList[1][2].y = 600
        roomList.enemyList[1][2].speed = 10
        roomList.enemyList[1][2].health = 4
        roomList.enemyList[1][2].damage = 5
        roomList.enemyList[1][2].follow = true
        roomList.enemyList[1][2].patrol = "square"
        roomList.enemyList[1][2].pathx = 40
        roomList.enemyList[1][2].pathy = 60
        roomList.enemyList[1][2].pathCounter = 1

        roomList.enemyList[2] = {}
        roomList.enemyList[2][1] = {}
        roomList.enemyList[2][1].x = 500
        roomList.enemyList[2][1].y = 700
        roomList.enemyList[2][1].speed = 400
        roomList.enemyList[2][1].health = 4
        roomList.enemyList[2][1].damage = 50
        roomList.enemyList[2][1].follow = false
        roomList.enemyList[2][1].patrol = "linex"
        roomList.enemyList[2][1].pathx = 700
        roomList.enemyList[2][1].pathy = 1000
        roomList.enemyList[2][1].pathCounter = 1


        local currentRoom = {}
        local lastRoom = currentRoom
        local lvlNumber = 1

        local function createLevel( lvlNumber)

          if lvlNumber==1 then
            room = display.newImageRect( backGroup, "roomType1.png", 1920, 1536 )
            room.x = display.contentCenterX
            room.y = display.contentCenterY+150
          elseif lvlNumber==2 then
            room = display.newImageRect( backGroup, "roomType4.png", 1900, 1516 )
            room.x = display.contentCenterX
            room.y = display.contentCenterY
          end

          currentRoom = {}
          currentRoom.lvlNumber = lvlNumber
          local totalItems = 0
          local roomWalls = roomList.wallList[lvlNumber]
          print(#roomWalls)
          local i = 1
          while (roomList.wallList[lvlNumber][i] ~= nil) do
            local wallInfo = roomList.wallList[lvlNumber][i]
            wall = display.newImageRect(charGroup, "transp.png", wallInfo.width, wallInfo.height)
            wall.x = wallInfo.x
            wall.y = wallInfo.y
            physics.addBody(wall, "static")
            wall.myName = "wall"
            currentRoom[totalItems] = wall
            totalItems = totalItems+1
            i = i+1
          end

          local roomDoors = roomList.doorList[lvlNumber]
          local i = 1
          while (roomList.doorList[lvlNumber][i] ~= nil) do
            local doorInfo = roomList.doorList[lvlNumber][i]
            door = display.newImageRect(charGroup, "transp.png", doorInfo.width, doorInfo.height)
            door.x = doorInfo.x
            door.y = doorInfo.y
            door.teleportTo = doorInfo.teleportTo
            door.playerX = doorInfo.playerX
            door.playerY = doorInfo.playerY
            physics.addBody(door, "static")
            door.myName = "door"
            currentRoom[totalItems] = door
            --totalDoors = totalDoors+1
            totalItems = totalItems+1
            i = i+1
          end
          local i = 1
          while (roomList.enemyList[lvlNumber][i] ~= nil) do
            local enemyInfo = roomList.enemyList[lvlNumber][i]
            enemy = createEnemy( enemyInfo.x, enemyInfo.y, enemyInfo.speed, enemyInfo.health, enemyInfo.damage, enemyInfo.follow, enemyInfo.patrol, enemyInfo.pathx, enemyInfo.pathy, enemyInfo.pathCounter )
            currentRoom[totalItems] = enemy
            --totalDoors = totalDoors+1
            totalItems = totalItems+1
            i = i+1
          end
          healthBar:toFront()
        end


        local function destroyLevel( totalItems)

          local i = totalItems - 1
          while (i>=0) do
            local objInfo = currentRoom[i]
            -- if objInfo.myName == "wall" then
            --   wall = display.remove(wall)
            --   physics.removeBody(wall)
            --   i = i-1
            -- elseif objInfo.myName == "door" then
            --   door = display.remove(door)
            --   physics.removeBody(door)
            --   i = i-1
            -- end
              display.remove(objInfo)
              physics.removeBody(objInfo)
              objInfo = nil
              i = i-1
          end
          display.remove(room)
          Enemies = {}
        end

        local function ChangeRoom ( event, lvlNumber )

          local obj1 = event.object1
          local obj2 = event.object2

          if ( obj1.myName == "player" and obj2.myName == "door" )
          then
            lastRoom = currentRoom
            print(" lvlNumber : " .. currentRoom.lvlNumber)
            lvl = currentRoom.lvlNumber
            local i = 0
            while (currentRoom[i] ~= nil) do
              i=i+1
            end
            print(i .. " = i ")
            timer.performWithDelay(1, function() destroyLevel(i) createLevel(obj2.teleportTo) charImage.x = obj2.playerX
            charImage.y = obj2.playerY end)

        elseif
             ( obj1.myName == "door" and obj2.myName == "player" )
          then

            lastRoom = currentRoom
            print(" lvlNumber : " .. currentRoom.lvlNumber)
            lvl = currentRoom.lvlNumber
            local i = 0
            while (currentRoom[i] ~= nil) do
              i=i+1
            end
            print(i .. " = i ")
            timer.performWithDelay(1, function() destroyLevel(i) createLevel(obj1.teleportTo) charImage.x = obj1.playerX
            charImage.y = obj1.playerY  end)

          end


        end

        createLevel(lvlNumber)
        local ind = 1
        while (currentRoom[ind] ~= nil) do
          ind=ind+1
        end
        print(" currentRoom : " .. ind .. " , " .. currentRoom.lvlNumber)

        Runtime:addEventListener( "collision", ChangeRoom )

        -- Hide status bar
        display.setStatusBar( display.HiddenStatusBar )
        --composer.gotoScene( "menu" )

        ----------------------
        -----
        -- change worlds
        -----
        ----------------------

        local function changeWorld()
          if(filter.alpha == 0) then
            noFilter=true
          else
            noFilter=false
          end

          if(noFilter == true) then --add a filter for the imaginary world
            filter.alpha = 0.5
            canCollect = true
            if (itemsLeft) then
              item1.alpha = 1
            end
          elseif(noFilter == false) then --remove the filter for the real world
            filter.alpha = 0
            if (itemsLeft) then
              item1.alpha = 0
            end
            canCollect = false;
          end

        end

        ----------------------
        -----
        -- item collection
        -----
        ----------------------

        local function collectItem()
          if(canCollect and itemCount < 1) then
            -- if char.x and .y == item.x and .y (within key bounds)
            -- then remove item and add to itemCount
            if ((charImage.x <= (item1.x + 50)) and (charImage.x >= item1.x - 50)) then
              if ((charImage.y >= (item1.y - 87)) and (charImage.y <= item1.y + 87)) then
                itemCount = itemCount + 1
                print(itemCount)
                -- item1:removeSelf()
                -- item1 = nil
                item1.alpha = 0;
                local printText = display.newText( "You win!", 350, 650, native.systemFont, 200) --prints "You win!" onto the screen
                itemsLeft = false
                canCollect = false;
              end
            end 
          end
        end

        Runtime:addEventListener( "enterFrame", collectItem)

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

          -- space change filter
          if(event.keyName == "space") then
            if(buttonPressed == true) then
              changeWorld()
            end
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
