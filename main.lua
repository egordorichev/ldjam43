RELEASE = (arg[2] == nil)
DEBUG = not RELEASE
CX = 0
CY = 0

libs = require "l2.libs"

for i, m in ipairs(require "require") do
	local succes, message = pcall(require, m)

	if not succes then
		if message:match("not found:") then
			print(message)
			requireDir("l2/" .. m)
		else
			error(message)
		end
	end
end

function love.load()
	game:init(InGameState())

	Input.register({
	   [ "up" ] = { "up", "w" },
 	   [ "left" ] = { "left", "a" },
 	   [ "down" ] = { "down", "s" },
 	   [ "right" ] = { "right", "d" }
	})
end

function love.update(dt)
	libs.update()
	game:update(dt)
end

function love.focus(focus)
	game.paused = not focus

	if focus then

	end
end

function love.draw()
	game:draw()
end

function love.keypressed(key)
	game:keyPressed(key)
end

function love.mousepressed(x, y, button)
	game:mousePressed(x, y, button)
end

function love.resize(w, h)
	SCALE = math.min(w / WIDTH, h / HEIGHT)
	CX = (w - SCALE * WIDTH) / 2
	CY = (h - SCALE * HEIGHT) / 2
end

function love.quit()
	game:save()
end