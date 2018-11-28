Player = Entity:extend()

function Player:new()
	Player.super.new(self)

	self:loadImage("data/images/player.png", 16, 16)
	self:addAnimation("idle", { 1, 2, 3, 4, 5, 6, 7, 8 }, 14)
	self:playAnimation("idle")

	self.moves = true
	self.id = "player"
	self.maxVelocity = nil
end

function Player:update(dt)
	local s = 512

	if Input.isDown("right") then
		self.accel.x = s
	end

	if Input.isDown("left") then
		self.accel.x = self.accel.x - s
	end

	if Input.isDown("up") then
		self.accel.y = -s
	end

	if Input.isDown("down") then
		self.accel.y = self.accel.x + s
	end

	Player.super.update(self, dt)
	self.velocity = self.velocity - self.velocity * dt * 4
end

function Player:onClick()
	self:flicker()
end

player = Player()