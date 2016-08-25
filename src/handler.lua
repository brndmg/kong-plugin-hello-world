local BasePlugin = require "kong.plugins.base_plugin"
local access = require "kong.plugins.hello-world.access"

local HelloWorldHandler = BasePlugin:extend()

function HelloWorldHandler:new()
  HelloWorldHandler.super.new(self, "hello-world")
end

function HelloWorldHandler:access(conf)
  HelloWorldHandler.super.access(self)
  access.execute(conf)
end

return HelloWorldHandler
