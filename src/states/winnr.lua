require("lib/essential")
require("lib/states/state")
require("lib/graphics/color")
require("src/flashingscreen")

WinnrState = class("WinnrState", State)

function WinnrState:initialize ()
	super.initialize(self)
	self.sounds = {
		win = love.audio.newSource("resources/sounds/win.wav", "static"),
	}
	self.images = {
		cake = love.graphics.newImage("resources/images/cake.png"),
	}
	self.animations = {
		winnr = FlashingScreen:new(1.2, nil, {
			Color:new(20, 20, 20, 70),
			Color:new(40, 40, 40, 70),
			Color:new(60, 60, 60, 70),
		})
	}
	self.fonts = {
		text = love.graphics.newImageFont("resources/fonts/font-24-white-black.png",
			" 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
			"`~!@#$%^&*()-=+_[]{}/\\|;:'\",.<>?"),
	}
end

function WinnrState:enter (ref)
	love.audio.stop()
	love.audio.play(self.sounds.win)
	self.animations.winnr:play()
	
	love.graphics.setFont(self.fonts.text)
end

function WinnrState:update (ref, dt)
	self.animations.winnr:update(dt)
end

function WinnrState:draw (ref)
	super.draw(self, ref)
	local color = Color:new(255, 255, 255, 210)
	local width, height = dimensions()
	color:set()
	love.graphics.rectangle("fill", 0, 0, width, height)
	self.animations.winnr:draw()
	
	Color.WHITE:set()
	
	-- Draw some cake.
	local x = width/2-self.images.cake:getWidth()/2
	local y = height/2-self.images.cake:getHeight()/2
	love.graphics.draw(self.images.cake, x, y)
	
	local tries = game.states.towlr.grid.tries
	love.graphics.printf("Winnr! Cake in only " .. tries .. " tr" .. (tries == 1 and "y" or "ies") .. "!",
		0, 198, width, "center")
	love.graphics.printf("Press SPACE to play again.", 0, 278, width, "center")
end

function WinnrState:keypressed (ref, key, unicode)
	local game = ref
	if key == " " then
		game:popState()
	end
end
