require("lib/essential")

Grid = class("Grid")

local function makeBoard ()
	local board = {}
	local content = love.filesystem.read(BOARD_PATH)
	for _,line in ipairs(content:split("\n")) do
		table.insert(board, line:chars())
	end
	return board
end

function Grid:initialize (towlr, bounds)
	self.towlr = towlr
	self.bounds = bounds
	self.tiles = {
		["1"] = love.graphics.newImage("resources/images/t1.gif"),
		["x"] = love.graphics.newImage("resources/images/t2.gif"),
		["-"] = love.graphics.newImage("resources/images/t3.gif"),
		["user"] = love.graphics.newImage("resources/images/t4.gif")
	}
	self:reset()
	self.tries = 0
end

function Grid:reset ()
	self.piecePosition = Vector2:new(13, 9)
	self.board = makeBoard()
	self.move = 0
end

function Grid:update (dt)
	if self.moved then
		for i=0,self.bounds.height/TILE_HEIGHT-1 do
			local row = self.board[i+1]
			for j=0,self.bounds.width/TILE_WIDTH-1 do
				local square = row[j+1]
				if square == "x" then
					self.board[i+1][j+1] = "-"
				elseif square == "-" then
					self.board[i+1][j+1] = "x"
				end
			end
		end
		self.moved = false
		local p = self.piecePosition
		if self.board[p.y+1] and self.board[p.y+1][p.x+1] ~= "-" then
			return "goodmove"
		else
			return nil
		end
	end
	
	local p = self.piecePosition
	if not self.board[p.y+1] or self.board[p.y+1][p.x+1] == "-" or
	   p.x < 0 or p.y < 0 or
	   p.x > self.bounds.width/TILE_WIDTH-1 or
	   p.y > self.bounds.height/TILE_HEIGHT-1 then
		self.tries = self.tries + 1
		return "lose"
	elseif p.x == 0 and p.y == 0 then
		self.tries = self.tries + 1
		return "win"
	end
end

function Grid:draw ()
	for i=0,self.bounds.height/TILE_HEIGHT-1 do
		local row = self.board[i+1]
		for j=0,self.bounds.width/TILE_WIDTH-1 do
			local square = row[j+1]
			local tile = self.tiles[square]
			love.graphics.draw(tile, j*TILE_WIDTH, i*TILE_HEIGHT)
		end
	end
	local p = self.piecePosition
	love.graphics.draw(self.tiles["user"], p.x*TILE_WIDTH, p.y*TILE_HEIGHT)
end

function Grid:keypressed (key, unicode)
	if key == "up" then
		self.piecePosition.y = self.piecePosition.y - 1
		self.moved = true
		self.move = self.move + 1
	elseif key == "down" then
		self.piecePosition.y = self.piecePosition.y + 1
		self.moved = true
		self.move = self.move + 1
	elseif key == "left" then
		self.piecePosition.x = self.piecePosition.x - 1
		self.moved = true
		self.move = self.move + 1
	elseif key == "right" then
		self.piecePosition.x = self.piecePosition.x + 1
		self.moved = true
		self.move = self.move + 1
	end
end
