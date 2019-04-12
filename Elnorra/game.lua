
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

        local composer = require( "composer" )

        local physics = require ("physics")
        physics.start()
        --physics.setDrawMode("hybrid")
        physics.setGravity( 0,0)

        -- Set up display groups
        local backGroup = display.newGroup()  -- Display group for the background image
        local charGroup = display.newGroup()  -- Display group for the hero, ennemys, weapon held, etc.
        local uiGroup = display.newGroup()

        local healthBar = display.newImageRect( "health_bar.png",healthScore*2,50 )
        healthBar.x = display.contentCenterX-720
        healthBar.y = display.contentCenterY-535
        local healthText = display.newText( healthScore, -200, 100, native.systemFont, 60)

        charImage = display.newImageRect(charGroup, "Sprites/hero.png", 70, 100)
        charImage.x = 500
        charImage.y = 500
        physics.addBody( charImage, "dynamic")
        charImage.isFixedRotation = true
        charImage.myName = "player"

        -- ----------some Sprites sheets --------
        --
        -- -- Config img sheet
        -- local sheetChair =
        -- {
        --   frames =
        --   { -- !!! The order in which you declare each image within a sheet is very important — later, when you load an image from a sheet using a command such as display.newImageRect(), you'll need to specify the number of the frame based on the order in which it was declared in the sheet configuration. !!!
        --         {   -- 1) front
        --             x=0,
        --             y = 0,
        --             width = 24,
        --             height = 32,
        --         },
        --         { -- 2) back
        --           x = 32,
        --           y = 6, -- apres height ast1
        --           width = 24,
        --           height = 26,
        --         },
        --         {   -- 3) ToTheRight
        --             x = 3,
        --             y = 32,
        --             width = 20,
        --             height = 31
        --         },
        --         {   -- 4) ToTheLeft
        --             x = 35,
        --             y = 32,
        --             width = 20,
        --             height = 31
        --         },
        --       },
        -- }
        -- local chairObjectSheet = graphics.newImageSheet("furnitures/chairs.png", sheetChair)

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

        -----------------------------------------

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
        roomList.decorList = {}
        roomList.itemList = {}



        -- ROOM 1 - KIDS ROOM
        --Walls--------------
        roomList.wallList[1] = {}
        roomList.wallList[1][1] = {}
        roomList.wallList[1][1].x = 5
        roomList.wallList[1][1].y = 550
        roomList.wallList[1][1].width = 14
        roomList.wallList[1][1].height = 1000

        roomList.wallList[1][2] = {}
        roomList.wallList[1][2].x = 740
        roomList.wallList[1][2].y = 550
        roomList.wallList[1][2].width = 14
        roomList.wallList[1][2].height = 1000

        roomList.wallList[1][3] = {}
        roomList.wallList[1][3].x = 380
        roomList.wallList[1][3].y = 230
        roomList.wallList[1][3].width = 750
        roomList.wallList[1][3].height = 14

        roomList.wallList[1][4] = {}
        roomList.wallList[1][4].x = 145
        roomList.wallList[1][4].y = 1100
        roomList.wallList[1][4].width = 300
        roomList.wallList[1][4].height = 160

        roomList.wallList[1][5] = {}
        roomList.wallList[1][5].x = 590
        roomList.wallList[1][5].y = 1100
        roomList.wallList[1][5].width = 300
        roomList.wallList[1][5].height = 160

        --Doors ----------
        roomList.doorList = {}
        roomList.doorList[1] = {}
        roomList.doorList[1][1] = {}
        roomList.doorList[1][1].x = 365
        roomList.doorList[1][1].y = 1135
        roomList.doorList[1][1].width = 110
        roomList.doorList[1][1].height = 80
        roomList.doorList[1][1].teleportTo = 2
        roomList.doorList[1][1].playerX = 460
        roomList.doorList[1][1].playerY = 400

        --Decor------
        roomList.decorList = {}
        roomList.decorList[1] = {}
        roomList.decorList[1][1] = {}
        roomList.decorList[1][1].x = 600
        roomList.decorList[1][1].y = 550
        roomList.decorList[1][1].width = 90
        roomList.decorList[1][1].height = 140
        roomList.decorList[1][1].myName = "simpleBed"
        roomList.decorList[1][1].linkedImg = "furnitures/bedGr.png"

        roomList.decorList[1][2] = {}
        roomList.decorList[1][2].x = 170
        roomList.decorList[1][2].y = 830
        roomList.decorList[1][2].width = 90
        roomList.decorList[1][2].height = 140
        roomList.decorList[1][2].myName = "simpleBed"
        roomList.decorList[1][2].linkedImg = "furnitures/bedS.png"

        roomList.decorList[1][3] = {}
        roomList.decorList[1][3].x = 520
        roomList.decorList[1][3].y = 520
        roomList.decorList[1][3].width = 65
        roomList.decorList[1][3].height = 60
        roomList.decorList[1][3].myName = "nightstand"
        roomList.decorList[1][3].linkedImg = "furnitures/nightstand.png"

        roomList.decorList[1][4] = {}
        roomList.decorList[1][4].x = 76
        roomList.decorList[1][4].y = 283
        roomList.decorList[1][4].width = 120
        roomList.decorList[1][4].height = 140
        roomList.decorList[1][4].myName = "lib"
        roomList.decorList[1][4].linkedImg = "furnitures/librairy.png"

        roomList.decorList[1][5] = {}
        roomList.decorList[1][5].x = 220
        roomList.decorList[1][5].y = 313
        roomList.decorList[1][5].width = 150
        roomList.decorList[1][5].height = 80
        roomList.decorList[1][5].myName = "dresser"
        roomList.decorList[1][5].linkedImg = "furnitures/dresser.png"

        roomList.decorList[1][6] = {}
        roomList.decorList[1][6].x = 400
        roomList.decorList[1][6].y = 283
        roomList.decorList[1][6].width = 120
        roomList.decorList[1][6].height = 140
        roomList.decorList[1][6].myName = "dresser"
        roomList.decorList[1][6].linkedImg = "furnitures/dresser2.png"

        roomList.decorList[1][7] = {}
        roomList.decorList[1][7].x = 550
        roomList.decorList[1][7].y = 283
        roomList.decorList[1][7].width = 120
        roomList.decorList[1][7].height = 140
        roomList.decorList[1][7].myName = "bookshelf"
        roomList.decorList[1][7].linkedImg = "furnitures/d-bookshelf-brown.png"

        roomList.decorList[1][8] = {}
        roomList.decorList[1][8].x = 670
        roomList.decorList[1][8].y = 283
        roomList.decorList[1][8].width = 120
        roomList.decorList[1][8].height = 140
        roomList.decorList[1][8].myName = "bookshelf"
        roomList.decorList[1][8].linkedImg = "furnitures/bookshelf-brown.png"

        --Items (pickable)---------
        roomList.itemList[1] = {}
        roomList.itemList[1][1] = {}
        roomList.itemList[1][1].x = 300
        roomList.itemList[1][1].y = 650
        roomList.itemList[1][1].width = 45
        roomList.itemList[1][1].height = 55
        roomList.itemList[1][1].myName = "toy"
        roomList.itemList[1][1].linkedImg = "furnitures/toy3.png"

        roomList.itemList[1][2] = {}
        roomList.itemList[1][2].x = 360
        roomList.itemList[1][2].y = 670
        roomList.itemList[1][2].width = 55
        roomList.itemList[1][2].height = 45
        roomList.itemList[1][2].myName = "toy"
        roomList.itemList[1][2].linkedImg = "furnitures/toy2.2.png"

        roomList.itemList[1][3] = {}
        roomList.itemList[1][3].x = 50
        roomList.itemList[1][3].y = 990
        roomList.itemList[1][3].width = 55
        roomList.itemList[1][3].height = 55
        roomList.itemList[1][3].myName = "toy"
        roomList.itemList[1][3].linkedImg = "furnitures/toy4.png"

        --Ennemies------------
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


        --ROOM 2 --- LIVINGROOM
        -- Walls---------------
        roomList.wallList[2] = {}
        roomList.wallList[2][1] = {}
        roomList.wallList[2][1].x = -200
        roomList.wallList[2][1].y = 290
        roomList.wallList[2][1].width = 125
        roomList.wallList[2][1].height = 600

        roomList.wallList[2][2] = {}
        roomList.wallList[2][2].x = 1060
        roomList.wallList[2][2].y = 595
        roomList.wallList[2][2].width = 14
        roomList.wallList[2][2].height = 1200

        roomList.wallList[2][3] = {}
        roomList.wallList[2][3].x = 93
        roomList.wallList[2][3].y = 220
        roomList.wallList[2][3].width = 600
        roomList.wallList[2][3].height = 14

        roomList.wallList[2][4] = {}
        roomList.wallList[2][4].x = 185
        roomList.wallList[2][4].y = 1238
        roomList.wallList[2][4].width = 900
        roomList.wallList[2][4].height = 120

        roomList.wallList[2][5] = {}
        roomList.wallList[2][5].x = 928
        roomList.wallList[2][5].y = 1238
        roomList.wallList[2][5].width = 300
        roomList.wallList[2][5].height = 120

        roomList.wallList[2][6] = {}
        roomList.wallList[2][6].x = 820
        roomList.wallList[2][6].y = 220
        roomList.wallList[2][6].width = 600
        roomList.wallList[2][6].height = 14

        roomList.wallList[2][7] = {}
        roomList.wallList[2][7].x = -200
        roomList.wallList[2][7].y = 1008
        roomList.wallList[2][7].width = 125
        roomList.wallList[2][7].height = 350

        --Doors----------------
        roomList.doorList[2] = {}
        roomList.doorList[2][1] = {}
        roomList.doorList[2][1].x = 460
        roomList.doorList[2][1].y = 180
        roomList.doorList[2][1].width = 100
        roomList.doorList[2][1].height = 80
        roomList.doorList[2][1].teleportTo = 1
        roomList.doorList[2][1].playerX = 365
        roomList.doorList[2][1].playerY = 1000

        -- roomList.doorList[2][2] = {}
        -- roomList.doorList[2][2].x = 710
        -- roomList.doorList[2][2].y = 1288
        -- roomList.doorList[2][2].width = 150
        -- roomList.doorList[2][2].height = 100
        -- roomList.doorList[2][2].teleportTo = 1
        -- roomList.doorList[2][2].playerX = 500
        -- roomList.doorList[2][2].playerY = 400

        --Decor------
        roomList.decorList[2] = {}
        roomList.decorList[2][4] = {}
        roomList.decorList[2][4].x = 800
        roomList.decorList[2][4].y = 900
        roomList.decorList[2][4].width = 180
        roomList.decorList[2][4].height = 180
        roomList.decorList[2][4].myName = "table"
        roomList.decorList[2][4].linkedImg = "furnitures/tableR.png"

        roomList.decorList[2][2] = {}
        roomList.decorList[2][2].x = 650
        roomList.decorList[2][2].y = 920
        roomList.decorList[2][2].width = 75
        roomList.decorList[2][2].height = 95
        roomList.decorList[2][2].myName = "chair"
        roomList.decorList[2][2].linkedImg = "furnitures/rightCh.png"

        roomList.decorList[2][3] = {}
        roomList.decorList[2][3].x = 950
        roomList.decorList[2][3].y = 920
        roomList.decorList[2][3].width = 80
        roomList.decorList[2][3].height = 95
        roomList.decorList[2][3].myName = "chair"
        roomList.decorList[2][3].linkedImg = "furnitures/lefttCh.png"

        roomList.decorList[2][1] = {}
        roomList.decorList[2][1].x = 800
        roomList.decorList[2][1].y = 790
        roomList.decorList[2][1].width = 75
        roomList.decorList[2][1].height = 90
        roomList.decorList[2][1].myName = "chair"
        roomList.decorList[2][1].linkedImg = "furnitures/frontCh.png"

        --Items (pickable)---------
        roomList.itemList[2] = {}
        roomList.itemList[2][1] = {}
        roomList.itemList[2][1].x = 300
        roomList.itemList[2][1].y = 650
        roomList.itemList[2][1].width = 15
        roomList.itemList[2][1].height = 45
        roomList.itemList[2][1].myName = "pen"
        roomList.itemList[2][1].linkedImg = "furnitures/pen.png"

        --Enemies ------------------
        roomList.enemyList[2] = {}
        roomList.enemyList[2][1] = {}
        roomList.enemyList[2][1].x = 250
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
            totalItems = totalItems+1
            i = i+1
          end
          local roomDecor = roomList.decorList[lvlNumber]
          local i = 1
          while (roomList.decorList[lvlNumber][i] ~= nil) do
            local decorInfo = roomList.decorList[lvlNumber][i]
            decor = display.newImageRect(charGroup, ""..decorInfo.linkedImg, decorInfo.width, decorInfo.height)
            decor.x = decorInfo.x
            decor.y = decorInfo.y
            physics.addBody(decor, "static")
            decor.myName = decorInfo.myName
            currentRoom[totalItems] = decor
            totalItems = totalItems+1
            i = i+1
          end
          local roomItems = roomList.itemList[lvlNumber]
          local i = 1
          while (roomList.itemList[lvlNumber][i] ~= nil) do
            local itemInfo = roomList.itemList[lvlNumber][i]
            item = display.newImageRect(charGroup, ""..itemInfo.linkedImg, itemInfo.width, itemInfo.height)
            item.x = itemInfo.x
            item.y = itemInfo.y
            --physics.addBody(decor, "static")
            item.myName = itemInfo.myName
            currentRoom[totalItems] = item
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
        -- remove display objects: https://docs.coronalabs.com/guide/media/displayObjects/index.html#removing-display-objects
        -- masking images https://docs.coronalabs.com/guide/media/imageMask/index.html


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
        local speed = 8 -- can be changed in other parts of code if needed

        -- every frame move (or dont move) the character depending on dir
        local function moveChar()
          if(dir == 8) then
            charImage.y = charImage.y - 8
          elseif(dir == 4) then
            charImage.x = charImage.x - 8
          elseif (dir == 2) then
            charImage.y = charImage.y + 8
          elseif(dir == 6) then
            charImage.x = charImage.x + 8
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
