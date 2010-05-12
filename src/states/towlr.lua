require("lib/essential")
require("lib/states/state")
require("lib/graphics/anal")
require("lib/graphics/utils")
require("lib/graphics/color")
require("lib/graphics/rect")
require("src/grid")
require("src/flashingscreen")

TowlrState = class("TowlrState", State)

function TowlrState:initialize ()
	super.initialize(self)
	self.width, self.height = dimensions()
	local bounds = Rect:new(Vector2:new(0, 0), self.width, self.height)
	self.grid = Grid:new(self, bounds)
	self.sounds = {
		lose = love.audio.newSource("resources/sounds/lose.wav", "static"),
		goodmove = love.audio.newSource("resources/sounds/goodmove.wav", "static"),
	}
	self.images = {
		plus = love.graphics.newImage("resources/images/plus.gif"),
		plus2 = love.graphics.newImage("resources/images/plus2.gif"),
	}
	self.animations = {
		plus2 = newAnimation(self.images.plus2, 24, 24, 0.12, 0),
		lose = FlashingScreen:new(0.05, 3, {
			Color:new(231, 132, 23, 150),
			Color:new(132, 23, 231, 150),
			Color:new(23, 132, 231, 150),
		})
	}
	self.animations.plus2:setMode("bounce")
	self.fonts = {
		tries = love.graphics.newImageFont("resources/fonts/font-24-red-pink.png",
			" 0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
			"`~!@#$%^&*()-=+_[]{}/\\|;:'\",.<>?"),
	}
end

function TowlrState:reset ()
	self.grid:reset()
end

function TowlrState:enter (ref)
	self:reset()
	self.grid.tries = 0
	love.graphics.setFont(self.fonts.tries)
end

function TowlrState:idleOut (ref)
	self:enter(ref)
end

function TowlrState:update (ref, dt)
	if self.idle then return end
	
	-- Update the grid.
	local game = ref
	local result = self.grid:update(dt)
	if result == "win" then
		game:pushState("winnr")
	elseif result == "lose" then
		if not self.sounds.lose:isStopped() then
			love.audio.stop()
		end
		love.audio.play(self.sounds.lose)
		if self.animations.lose:isPlaying() then
			self.animations.lose:stop()
		end
		self.animations.lose:play()
		self:reset()
	elseif result == "goodmove" then
		if not self.sounds.goodmove:isStopped() then
			love.audio.stop()
		end
		love.audio.play(self.sounds.goodmove)
	end
	
	-- Update the animated '+'.
	if self.grid.move % 2 == 1 then
		self.animations.plus2:update(dt)
	end
	
	-- Update the lose animation if it applies.
	if self.animations.lose:isPlaying() then
		self.animations.lose:update(dt)
	end
end

function TowlrState:draw (ref)
	-- Draw the grid.
	Color.WHITE:set()
	self.grid:draw()
	
	-- Draw the obligatory '+' in the middle of the screen.
	local x = self.width/2-self.images.plus:getWidth()/2
	local y = self.height/2-self.images.plus:getHeight()/2
	if self.grid.move % 2 == 0 then
		love.graphics.draw(self.images.plus, x, y)
	else
		self.animations.plus2:draw(x, y)
	end
	
	-- Draw the number of tries.
	love.graphics.printf(tostring(self.grid.tries), 0, 5, self.width-5, "right")
	
	-- Draw the lose animation if it applies.
	if self.animations.lose:isPlaying() then
		self.animations.lose:draw()
	end
end

function TowlrState:keypressed (ref, key, unicode)
	if self.idle then return end
	
	self.grid:keypressed(key, unicode)
end
