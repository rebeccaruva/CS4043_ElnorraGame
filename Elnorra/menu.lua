
local composer = require( "composer" )

local scene = composer.newScene()

local backGroup
local mainGroup

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

local function settings_pop_up()
native.newTextBox( display.contentCenterX, display.contentCenterY, 600, 400 )

end
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local background = display.newImage(sceneGroup, "pixel_high_res.png" )
  local scale = math.max(display.contentWidth / background.width, display.contentHeight / background.height)
  background:scale(scale, scale)
  background.x = display.contentCenterX
  background.y = display.contentCenterY

  local menu_title = display.newImage( "title.png" )
  menu_title.x = display.contentCenterX
  menu_title.y = display.contentHeight - 1000

  local menu_tap_to_play = display.newText("Tap to play", display.contentCenterX, display.contentHeight - 600, "Arial", 140)
  transition.blink(menu_tap_to_play, {time=3000})

  local menu_settings = display.newImage("settings_icon.png")
  menu_settings.x = display.contentCenterX + 1000
  menu_settings.y = display.contentHeight - 100


    menu_settings:addEventListener( "tap", settings_pop_up )
end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

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

--[[local options =
{
    effect = "fade",
    time = 100,
    params =
        {
            sample_var = "anything parameter to send",
            theme = "another parameter to send",
            data = "another parameter to send"
        },
    isModal = true
}

storyboard.showOverlay( "pause", options )

local options ={
    effect = "fade",
    time = 100,
    isModal = false,
}storyboard.hideOverlay( "pause", options )
--]]
