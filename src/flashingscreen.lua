require("lib/essential")
require("lib/graphics/animation")

FlashingScreen = class("FlashingScreen", Animation)

function FlashingScreen:initialize (delay, maxTimes, colors)
	local frames = {}
	local width, height = dimensions()
	for _,color in ipairs(colors) do
		table.insert(frames, { delay, function ()
			color:set()
			love.graphics.rectangle("fill", 0, 0, width, height)
		end })
	end
	super.initialize(self, frames, maxTimes)
end
