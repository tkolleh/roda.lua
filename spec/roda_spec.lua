---@diagnostic disable: undefined-global
local roda = require("roda")

describe("roda module", function()
  -- Mock stream to capture output without affecting terminal
  local function mock_stream()
    return {
      output = {},
      write = function(self, str)
        table.insert(self.output, str)
      end,
      flush = function() end,
    }
  end

  describe("constructor", function()
    it("should create spinner with string text", function()
      local spinner = roda("Loading...")
      assert.is_not_nil(spinner)
      assert.equals("Loading...", spinner:getText())
    end)

    it("should create spinner with options table", function()
      local spinner = roda({
        text = "Processing",
        color = "yellow",
        spinner = "line",
      })
      assert.is_not_nil(spinner)
      assert.equals("Processing", spinner:getText())
      assert.equals("yellow", spinner:getColor())
    end)

    it("should use default values when not specified", function()
      local spinner = roda({})
      assert.equals("", spinner:getText())
      assert.equals("cyan", spinner:getColor())
    end)

    it("should be callable as function", function()
      local spinner = roda("Test")
      assert.is_not_nil(spinner)
    end)

    it("should work with nil argument", function()
      local spinner = roda()
      assert.is_not_nil(spinner)
      assert.equals("", spinner:getText())
    end)
  end)

  describe("text methods", function()
    it("should get and set text", function()
      local spinner = roda("Initial")
      assert.equals("Initial", spinner:getText())
      spinner:setText("Updated")
      assert.equals("Updated", spinner:getText())
    end)

    it("should handle nil text by converting to empty string", function()
      local spinner = roda("Test")
      spinner:setText(nil)
      assert.equals("", spinner:getText())
    end)

    it("should get and set prefix text", function()
      local spinner = roda({ prefixText = ">>>" })
      assert.equals(">>>", spinner:getPrefixText())
      spinner:setPrefixText("<<<")
      assert.equals("<<<", spinner:getPrefixText())
    end)

    it("should get and set suffix text", function()
      local spinner = roda({ suffixText = "..." })
      assert.equals("...", spinner:getSuffixText())
      spinner:setSuffixText("!!!")
      assert.equals("!!!", spinner:getSuffixText())
    end)

    it("should return self for chaining", function()
      local spinner = roda("Test")
      local result = spinner:setText("New")
      assert.equals(spinner, result)
    end)
  end)

  describe("color methods", function()
    it("should get and set color", function()
      local spinner = roda({ color = "red" })
      assert.equals("red", spinner:getColor())
      spinner:setColor("green")
      assert.equals("green", spinner:getColor())
    end)

    it("should accept false to disable color", function()
      local spinner = roda({ color = false })
      assert.equals(false, spinner:getColor())
    end)

    it("should use cyan as default color", function()
      local spinner = roda("Test")
      assert.equals("cyan", spinner:getColor())
    end)

    it("should return self for chaining", function()
      local spinner = roda("Test")
      local result = spinner:setColor("blue")
      assert.equals(spinner, result)
    end)
  end)

  describe("spinning state", function()
    it("should not be spinning initially", function()
      local spinner = roda("Test")
      assert.is_false(spinner:isSpinning())
    end)

    it("should be spinning after start", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      assert.is_true(spinner:isSpinning())
      spinner:stop()
    end)

    it("should not be spinning after stop", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      spinner:stop()
      assert.is_false(spinner:isSpinning())
    end)

    it("should not be spinning after succeed", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      spinner:succeed()
      assert.is_false(spinner:isSpinning())
    end)

    it("should not be spinning after fail", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      spinner:fail()
      assert.is_false(spinner:isSpinning())
    end)
  end)

  describe("frame method", function()
    it("should return current frame", function()
      local spinner = roda({ spinner = "dots" })
      local frame = spinner:frame()
      assert.is_string(frame)
      assert.is_true(#frame > 0)
    end)

    it("should return first frame initially", function()
      local spinner = roda({ spinner = "line" })
      local frame = spinner:frame()
      assert.equals("-", frame)
    end)
  end)

  describe("chainable methods", function()
    it("start should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      local result = spinner:start()
      assert.equals(spinner, result)
      spinner:stop()
    end)

    it("stop should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:stop()
      assert.equals(spinner, result)
    end)

    it("succeed should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:succeed("Done")
      assert.equals(spinner, result)
    end)

    it("fail should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:fail("Error")
      assert.equals(spinner, result)
    end)

    it("warn should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:warn("Warning")
      assert.equals(spinner, result)
    end)

    it("info should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:info("Info")
      assert.equals(spinner, result)
    end)

    it("spin should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:spin()
      assert.equals(spinner, result)
      spinner:stop()
    end)

    it("clear should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      local result = spinner:clear()
      assert.equals(spinner, result)
    end)

    it("stopAndPersist should return self", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      local result = spinner:stopAndPersist({ symbol = "*", text = "Done" })
      assert.equals(spinner, result)
    end)
  end)

  describe("start method", function()
    it("should allow setting text on start", function()
      local spinner = roda("Initial")
      spinner._stream = mock_stream()
      spinner:start("New text")
      assert.equals("New text", spinner:getText())
      spinner:stop()
    end)

    it("should be idempotent when already spinning", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      spinner:start()
      spinner:start() -- should not error
      assert.is_true(spinner:isSpinning())
      spinner:stop()
    end)
  end)

  describe("stop method", function()
    it("should be safe to call when not spinning", function()
      local spinner = roda("Test")
      spinner._stream = mock_stream()
      -- Should not error
      spinner:stop()
      assert.is_false(spinner:isSpinning())
    end)
  end)

  describe("terminal state methods", function()
    it("succeed should update text if provided", function()
      local stream = mock_stream()
      local spinner = roda("Working")
      spinner._stream = stream
      spinner:start()
      spinner:succeed("Completed!")
      
      -- Check that output contains the new text
      local output = table.concat(stream.output)
      assert.is_truthy(output:find("Completed!"))
    end)

    it("fail should update text if provided", function()
      local stream = mock_stream()
      local spinner = roda("Working")
      spinner._stream = stream
      spinner:start()
      spinner:fail("Error occurred")
      
      local output = table.concat(stream.output)
      assert.is_truthy(output:find("Error occurred"))
    end)
  end)

  describe("stopAndPersist", function()
    it("should use custom symbol", function()
      local stream = mock_stream()
      local spinner = roda("Test")
      spinner._stream = stream
      spinner:start()
      spinner:stopAndPersist({ symbol = "★", text = "Custom" })
      
      local output = table.concat(stream.output)
      assert.is_truthy(output:find("★"))
      assert.is_truthy(output:find("Custom"))
    end)

    it("should use current text if not provided", function()
      local stream = mock_stream()
      local spinner = roda("Original text")
      spinner._stream = stream
      spinner:start()
      spinner:stopAndPersist({ symbol = "→" })
      
      local output = table.concat(stream.output)
      assert.is_truthy(output:find("Original text"))
    end)
  end)
end)

describe("roda.new", function()
  it("should be equivalent to calling roda directly", function()
    local spinner1 = roda("Test")
    local spinner2 = roda.new("Test")
    assert.equals(spinner1:getText(), spinner2:getText())
    assert.equals(spinner1:getColor(), spinner2:getColor())
  end)
end)

describe("roda.promise", function()
  it("should be a function", function()
    assert.is_function(roda.promise)
  end)

  it("should return result on success", function()
    local stream = {
      write = function() end,
      flush = function() end,
    }
    
    -- Override default stream
    local original_stderr = io.stderr
    
    local result = roda.promise({
      text = "Working...",
      stream = stream,
      fn = function()
        return "success value"
      end,
    })
    
    assert.equals("success value", result)
  end)

  it("should return nil and error on failure", function()
    local stream = {
      write = function() end,
      flush = function() end,
    }
    
    local result, err = roda.promise({
      text = "Working...",
      stream = stream,
      fn = function()
        error("test error")
      end,
    })
    
    assert.is_nil(result)
    assert.is_truthy(err)
  end)
end)

describe("submodule exports", function()
  it("should export ansi submodule", function()
    assert.is_table(roda.ansi)
    assert.is_string(roda.ansi.reset)
  end)

  it("should export spinners submodule", function()
    assert.is_table(roda.spinners)
    assert.is_table(roda.spinners.dots)
  end)

  it("should export symbols submodule", function()
    assert.is_table(roda.symbols)
    assert.is_string(roda.symbols.succeed)
  end)
end)
