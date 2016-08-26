
local plugin_handler = require "kong.plugins.hello-world.handler"

describe("hello-world plugin", function()
  local old_ngx = _G.ngx
  -- local stubbed_ndx = nil
  local mock_config
  local handler

  before_each(function()
    local stubbed_ngx = {
      ERR = "ERROR:",
      header = {},
      log = function(...) end,
      say = function(...) end,
      exit = function(...) end
    }

    _G.ngx = stubbed_ngx
    stub(stubbed_ngx, "say")
    stub(stubbed_ngx, "exit")
    stub(stubbed_ngx, "log")

    handler = plugin_handler()
  end)

  after_each(function()
    _G.ngx = old_ngx
  end)

  describe("when say_hello is true", function()
    before_each(function()
      mock_config = {
        say_hello = true
      }
      handler:access(mock_config)
    end)

    it("adds the correct header value of Hello World!!!", function()
      assert.is_not.falsy(ngx.header['Hello-World'])
      assert.is_equal("Hello World!!!", ngx.header['Hello-World'])
    end)

    it("calls ngx.log", function()
      assert.stub(ngx.log).was.called_with("ERROR:", "============ Hello World! ============")
    end)
  end)

  describe("when say_hello is false", function()
    before_each(function()
      mock_config = {
        say_hello = false
      }
      handler:access(mock_config)
    end)

    it("adds the correct header value of Bye World!!!", function()
      assert.is_not.falsy(ngx.header['Hello-World'])
      assert.is_equal("Bye World!!!", ngx.header['Hello-World'])
    end)

    it("calls ngx.log", function()
      assert.stub(ngx.log).was.called_with("ERROR:", "============ Bye World! ============")
    end)
  end)
end)
