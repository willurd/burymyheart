--[[
Bury My Heart at Towlr Mountain is a Towlr game built using LOVE
(http://love2d.org), a lua 2D game engine.

@author William Bowers (willurd) <william.bowers@gmail.com>
--]]

require("lib/game")
require("src/states/towlr")
require("src/states/winnr")

function love.load (args)
	game = Game:new({
		towlr = TowlrState:new(),
		winnr = WinnrState:new()
	})
	game:changeState("towlr")
end

function love.update (dt)
	game:update(dt)
end

function love.draw ()
	game:draw()
end

function love.keypressed (key, unicode)
	game:keypressed(key, unicode)
end
