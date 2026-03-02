---@diagnostic disable: undefined-global
local symbols = require("roda.symbols")

describe("symbols module", function()
	it("should have succeed symbol", function()
		assert.is_string(symbols.succeed)
		assert.equals("✔", symbols.succeed)
	end)

	it("should have fail symbol", function()
		assert.is_string(symbols.fail)
		assert.equals("✖", symbols.fail)
	end)

	it("should have warn symbol", function()
		assert.is_string(symbols.warn)
		assert.equals("⚠", symbols.warn)
	end)

	it("should have info symbol", function()
		assert.is_string(symbols.info)
		assert.equals("ℹ", symbols.info)
	end)

	it("should have exactly 4 symbols", function()
		local count = 0
		for _ in pairs(symbols) do
			count = count + 1
		end
		assert.equals(4, count)
	end)
end)
