
local composer = require( "composer" )

local scene = composer.newScene()

local sceneGroup

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function goToGame()
 composer.gotoScene( "game" )
end

local function goToSettings()
 composer.gotoScene( "settings" )
 audio.play(sfx, {loops=-1})
end

local function goToCredits()
 composer.gotoScene( "credits" )
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen


  sfx = audio.loadStream("sfx_test.mp3")
  music = audio.loadStream( "pillars-of-eternity-elmshore.mp3" )
    audio.play(music, {loops=-1, fadeIn=700})
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

    local background = display.newImage(sceneGroup, "pixel_high_res.png" )
    local scale = math.max(display.contentWidth / background.width, display.contentHeight / background.height)
    background:scale(scale, scale)
    background.x = display.contentCenterX
    background.y = display.contentCenterY

    local menu_title = display.newImage(sceneGroup, "title.png" )
    menu_title.x = display.contentCenterX
    menu_title.y = display.contentHeight - 1000

    local menu_tap_to_play = display.newText(sceneGroup, "Tap to play", display.contentCenterX, display.contentHeight - 600, "Arial", 140)
    transition.blink(menu_tap_to_play, {time=3000})

    local menu_settings = display.newImage(sceneGroup, "settings_icon.png")
    menu_settings.x = display.contentHeight + 50
    menu_settings.y = display.contentHeight -100

  	local credits = display.newImage(sceneGroup, "credits.png" )
  	credits.x = display.contentCenterX - 950
    credits.y = display.contentHeight - 100

    menu_settings:addEventListener( "tap", goToSettings )
    menu_tap_to_play:addEventListener( "tap", goToGame )

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
    if (composer.getSceneName("current") == "game") then
      audio.fadeOut( { channel=0 ,time=700 } )
    end
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
