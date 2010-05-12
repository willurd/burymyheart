--[[
Bury My Heart at Towlr Mountain is a Towlr game built using LOVE
(http://love2d.org), a lua 2D game engine.

@author William Bowers (willurd) <william.bowers@gmail.com>
--]]

BOARD_PATH = "resources/board.txt"
TILE_WIDTH = 50
TILE_HEIGHT = 50

love.filesystem.setIdentity("BuryMyHeart")

function love.conf (c)
	c.title = "Bury My Heart at Towlr Mountain"
	c.author = "willurd"
	
	c.modules.audio 	= true
	c.modules.event 	= true
	c.modules.graphics 	= true
	c.modules.image 	= true
	c.modules.joystick 	= false
	c.modules.keyboard 	= true
	c.modules.mouse 	= false
	c.modules.physics 	= false
	c.modules.sound 	= true
	c.modules.timer 	= true
	
	c.screen.fsaa = 0
	c.screen.fullscreen = false
	c.screen.height = 500
	c.screen.width = 700
	c.screen.vsync = true
end
