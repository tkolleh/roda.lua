---@diagnostic disable: undefined-global
local ansi = require("roda.ansi")

describe("ansi module", function()
	describe("cursor control codes", function()
		it("should have hide_cursor code", function()
			assert.is_string(ansi.hide_cursor)
			assert.equals("\27[?25l", ansi.hide_cursor)
		end)

		it("should have show_cursor code", function()
			assert.is_string(ansi.show_cursor)
			assert.equals("\27[?25h", ansi.show_cursor)
		end)

		it("should have clear_line code", function()
			assert.is_string(ansi.clear_line)
			assert.equals("\27[2K", ansi.clear_line)
		end)

		it("should have move_to_col_1 code", function()
			assert.is_string(ansi.move_to_col_1)
			assert.equals("\27[G", ansi.move_to_col_1)
		end)

		it("should have move_up code", function()
			assert.is_string(ansi.move_up)
			assert.equals("\27[A", ansi.move_up)
		end)
	end)

	describe("formatting codes", function()
		it("should have reset code", function()
			assert.is_string(ansi.reset)
			assert.equals("\27[0m", ansi.reset)
		end)

		it("should have bold code", function()
			assert.is_string(ansi.bold)
			assert.equals("\27[1m", ansi.bold)
		end)
	end)

	describe("color codes", function()
		it("should have colors table", function()
			assert.is_table(ansi.colors)
		end)

		local expected_colors = {
			black = "\27[30m",
			red = "\27[31m",
			green = "\27[32m",
			yellow = "\27[33m",
			blue = "\27[34m",
			magenta = "\27[35m",
			cyan = "\27[36m",
			white = "\27[37m",
			gray = "\27[90m",
		}

		for name, code in pairs(expected_colors) do
			it("should have correct " .. name .. " color code", function()
				assert.equals(code, ansi.colors[name])
			end)
		end
	end)

	describe("get_color function", function()
		it("should return color code for valid color name", function()
			local code = ansi.get_color("red")
			assert.equals(ansi.colors.red, code)
		end)

		it("should return green for 'green'", function()
			local code = ansi.get_color("green")
			assert.equals("\27[32m", code)
		end)

		it("should return cyan for unknown color", function()
			local code = ansi.get_color("unknown_color")
			assert.equals(ansi.colors.cyan, code)
		end)

		it("should return cyan for nil", function()
			local code = ansi.get_color(nil)
			assert.equals(ansi.colors.cyan, code)
		end)

		it("should return empty string when color is false", function()
			local code = ansi.get_color(false)
			assert.equals("", code)
		end)

		it("should return empty string when color is explicitly false", function()
			local code = ansi.get_color(false)
			assert.equals("", code)
		end)

		it("should handle true by returning cyan", function()
			-- true is not false, so it falls through to default
			local code = ansi.get_color(true)
			assert.equals(ansi.colors.cyan, code)
		end)
	end)

	describe("supports_color function", function()
		it("should exist", function()
			assert.is_function(ansi.supports_color)
		end)

		it("should return boolean", function()
			local result = ansi.supports_color()
			assert.is_boolean(result)
		end)
	end)
end)
