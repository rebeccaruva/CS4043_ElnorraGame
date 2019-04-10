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

        --set up display groups
        local healthText = display.newText(sceneGroup, healthScore, -200, 100, native.systemFont, 60)

        charImage = display.newImageRect(sceneGroup, "Sprites/char.png", 50, 50)
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


        backButton:addEventListener( "tap", goToMenu )

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
