Game = Object:extend()

local canvas
local shader

function Game:new()
  self.state = nil
  self.newState = nil
  self.dt = 0
  self.elapsed = 0
  self.paused = false
  self.speed = 1
	self.shakeAmount = 0
	self.shakeTimer = 0
	self.flashTimer = 0
	self.flashColor = nil
	self.backgroundColor = { 0.1, 0.1, 0.1 }
	self.drawCalls = 0

	shader = love.graphics.newShader [[
extern float elapsed;

vec2 radialDistortion(vec2 coord, float dist) {
  vec2 cc = coord - 0.5;
  dist = dot(cc, cc) * dist + cos(elapsed * .3) * .01;
  return (coord + cc * (1.0 + dist) * dist);
}

vec4 effect(vec4 color, Image tex, vec2 tc, vec2 pc) {
  vec2 tcr = radialDistortion(tc, .24)  + vec2(.001, 0);
  vec2 tcg = radialDistortion(tc, .20);
  vec2 tcb = radialDistortion(tc, .18) - vec2(.001, 0);
  vec4 res = vec4(Texel(tex, tcr).r, Texel(tex, tcg).g, Texel(tex, tcb).b, 1)
    - cos(tcg.y * 128. * 3.142 * 2) * .03
    - sin(tcg.x * 128. * 3.142 * 2) * .03;
  return res * Texel(tex, tcg).a;
}
]]

	canvas = love.graphics.newCanvas(WIDTH, HEIGHT)
	canvas:setFilter("nearest", "nearest")
end

function Game:init(state)
	self:switchState(state)

	if DEBUG then
		Debug.init()
	end
end

function Game:save()
	Save.flush()
end

function Game:switchState(state)
  self.newState = state
end

function Game:shake(amount, time)
	self.shakeAmount = amount or 2
	self.shakeTimer = math.abs(time or .5)
end

function Game:flash(color, time)
	self.flashTimer = time or .1
	self.flashColor = color or { 255, 255, 255 }
end

function Game:update(dt)
	if Debug.active then
    if self.paused then
      dt = 0
    else
      dt = dt * self.speed
    end
	end

  if self.newState ~= nil then
    if self.state then
      self.state:destroy()
    end

    self.state = self.newState
    self.state:init()
    self.newState = nil
  end

  self.dt = dt
  self.elapsed = self.elapsed + dt

	shader:send("elapsed", self.elapsed)

	if self.flashTimer > 0 then
    self.flashTimer = self.flashTimer - dt
	end

	if self.shakeTimer ~= 0 then
		self.shakeTimer = self.shakeTimer - dt

    if self.shakeTimer <= 0 then
			self.shakeTimer = 0
			self.shakeAmount = 0
		end
	end

	Input.update(dt)
  self.state:update(dt)
	Input.reset()
end

function Game:draw()
	love.graphics.setCanvas(canvas)
	love.graphics.clear(self.backgroundColor[1], self.backgroundColor[2], self.backgroundColor[3], 255)
	Game.camera:set()

	local shake = math.max(self.shakeAmount, 0)
	love.graphics.translate(shake * lume.random(-1, 1), shake * lume.random(-1, 1))

	self.state:draw()

	if self.flashTimer > 0 then
		love.graphics.clear(unpack(self.flashColor))
	end

	--love.graphics.setShader(shader)
	love.graphics.setCanvas()
	Game.camera:unset()
	love.graphics.draw(canvas, CX, CY, 0, SCALE, SCALE)
	love.graphics.setShader()

	Debug.draw()
	self.drawCalls = love.graphics.getStats().drawcalls
end

function Game:keyPressed(key)
	if DEBUG and key == "escape" then
		Debug.active = not Debug.active
	end

	if Debug.active then
		return
	end

	Input.onKeyPress(key)
end

function Game:mousePressed(x, y, btn)
	if Debug.active then
		return
	end

	Input.onMousePress(x, y, btn)

	local x, y = Input.getMousePosition()
	local zIndex = -math.huge
	local entity = nil

	self.state.scene.sh:each(x, y, 1, 1, function(e)
		if e.onClick ~= Entity.onClick and e.zIndex > zIndex then
	 		zIndex = e.zIndex
	    	entity = e
		end
	end)

	if entity then
		entity:onClick(btn)
	end
end

game = Game()