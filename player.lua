Player = Entity:extend()

function Player:new()
	Player.super.new(self)

	self:set(64, 64, 16, 16)

	self:loadImage("data/images/player.png", 16, 16)
	self:addAnimation("idle", { 1, 2, 3, 4, 5, 6, 7, 8 }, 14)
	self:playAnimation("idle")

	self.moves = true
	self.id = "player"
	self.maxVelocity = nil
	self.solid = true
	self.w = 8
	self.h = 15
	self.offset:set(-4, -1)

	Camera.follow = self
end

function Player:update(dt)
	local s = 512

	if Input.isDown("right") then
		self.accel.x = s
	end

	if Input.isDown("left") then
		self.accel.x = self.accel.x - s
	end

	if Input.isDown("up") and self.touching.bottom then
		self.velocity.y = -384
	end

	self.velocity.y = self.velocity.y + dt * 512

	Player.super.update(self, dt)
	self.velocity = self.velocity - self.velocity * dt * 4
end

function Player:onClick()
	self:flicker()
end