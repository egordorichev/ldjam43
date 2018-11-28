Camera = Entity:extend()

function Camera:new(follow)
  Camera.super.new(self)
  self.follow = follow
  self.speed = 2
	self.w = WIDTH
	self.h = HEIGHT

	Game.camera = self
end

function Camera:set()
  love.graphics.push()
  love.graphics.translate(-self.x, -self.y)
end

function Camera:unset()
  love.graphics.pop()
end

function Camera:update(dt)
  if self.follow ~= nil then
    if self:getDistance(self.follow) > 5 then
      self.x = lume.lerp(self.x, self.follow:centerX() - self.w / 2, self.speed * dt)

			if self.follow.velocity.y > 128 or self.follow.touching.bottom then
      	self.y = lume.lerp(self.y, self.follow:centerY() - self.h / 2, self.speed * 3 * dt)
			end
    end
  end
end