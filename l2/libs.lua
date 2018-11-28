require "lib.autobatch"

flux = require "lib.flux"
lume = require "lib.lume"
coil = require "lib.coil"
tick = require "lib.tick"
shash = require "lib.shash"
log = require "lib.log"
lurker = require "lib.lurker"
Object = require "lib.classic"

libs = {}

function libs.update(dt)
  flux.update(dt)
  tick.update(dt)
	lurker.update(dt)
end

return libs