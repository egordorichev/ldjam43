SCALE = 2
WIDTH = 320
HEIGHT = 180

function love.conf(t)
	t.releases = {
		title = "l2 engine",
		package = "l2",
		loveVersion = "0.10.2",
		version = "0.1",
		author = "Egor Dorichev",
		email = "egordorichev@gmail.com",
		description = "l2 engine template",
		homepage = nil,
		identifier = "l2",
		excludeFileList = {},
		releaseDirectory = nil
	}

	t.identity = "l2"
	t.version = "11.2"

	t.window.resizable = true
	t.window.title = "ldjam43 - @egordorichev"
	t.window.icon = "data/images/icon.png"
	t.window.width = WIDTH * SCALE
	t.window.height = HEIGHT * SCALE
	t.window.minwidth = WIDTH
	t.window.minheight = HEIGHT
end