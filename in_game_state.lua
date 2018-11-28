InGameState = State:extend()

function InGameState:init()
	InGameState.super.init(self)

	self.name = "ingame"

	player = Player()
	self.scene:add(player)

	map = Tilemap()
	map:loadLua("data/maps/1.lua", lume.fn(self.loadObject, self))

	map:loadMetaImage("data/images/meta.png", {
		["#000000"] = function(t)
			log.info("solid tile")
			t.solid = true
			t.static = true
			t.immovable = true
		end
	})

	self.scene:add(map)
end

function InGameState:loadObject(layer, obj)
	self.scene:destroy()
end

function InGameState:destroy()
	InGameState.super.destroy(self)
end

function InGameState:update(dt)
	InGameState.super.update(self, dt)
end

function InGameState:draw()
	InGameState.super.draw(self)
end