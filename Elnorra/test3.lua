
local composer = require( "composer" )

local scene = composer.newScene()
local sceneGroup
-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------
local music, sfx
local isSoundMuted = "false"
local isSfxMuted = "false"

local function goToMenu()
 composer.gotoScene( "menu")
end

function toggleSound()
  if isSoundMuted == "false" then
  audio.pause(1)
  isSoundMuted = "true"
else
  audio.resume(1)
  isSoundMuted = "false"
end
end


function toggleSfx()
  if isSfxMuted == "false" then
  audio.pause(2)
  isSfxMuted = "true"
else
  audio.resume(2)
  isSfxMuted = "false"
end
end



-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen




  music = audio.loadStream( "pillars-of-eternity-elmshore.mp3" )
    audio.play(music, {loops=-1, fadeIn=700})

    sfx = audio.loadStream("sfx_test.mp3")
    audio.play(sfx, {loops=-1})

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


		local backButton = display.newImage(sceneGroup, "Left-Arrow.png" )
		backButton.x = display.contentCenterX - 950
		backButton.y = display.contentHeight - 1150


		local musicText = display.newText(sceneGroup, "Background music :", display.contentCenterX - 200, display.contentHeight - 800, "Arial", 140)
		local musicButton = display.newImage(sceneGroup, "music_on.png" )
		musicButton.x = display.contentCenterX + 650
		musicButton.y = display.contentHeight - 800

		local sfxText = display.newText(sceneGroup, "Sound effects :", display.contentCenterX - 200, display.contentHeight - 500, "Arial", 140)
		local sfxButton

    sfxButton = display.newImage(sceneGroup, "sfx_on.png" )
    sfxButton.x = display.contentCenterX + 650
    sfxButton.y = display.contentHeight - 500



		musicButton:addEventListener( "tap", toggleSound )
		sfxButton:addEventListener( "tap", toggleSfx )
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
