---@diagnostic disable: undefined-global
local spinners = require("roda.spinners")

describe("spinners module", function()
	it("should have a default spinner name", function()
		assert.is_string(spinners.default)
		assert.is_not_nil(spinners[spinners.default])
	end)

	it("should have dots as the default spinner", function()
		assert.equals("dots", spinners.default)
	end)

	it("should have dots spinner with correct structure", function()
		assert.is_table(spinners.dots)
		assert.is_table(spinners.dots.frames)
		assert.is_number(spinners.dots.interval)
		assert.is_true(#spinners.dots.frames > 0)
		assert.equals(80, spinners.dots.interval)
	end)

	describe("all spinner definitions", function()
		local spinner_names = {
			"dots",
			"dots2",
			"dots3",
			"line",
			"line2",
			"pipe",
			"simpleDots",
			"star",
			"arc",
			"circle",
			"bounce",
			"bouncingBar",
			"arrow",
			"growVertical",
			"growHorizontal",
			"aesthetic",
		}

		for _, name in ipairs(spinner_names) do
			describe(name .. " spinner", function()
				it("should exist", function()
					assert.is_table(spinners[name], name .. " should exist")
				end)

				it("should have frames array", function()
					assert.is_table(spinners[name].frames, name .. " should have frames")
				end)

				it("should have at least one frame", function()
					assert.is_true(#spinners[name].frames > 0, name .. " should have at least one frame")
				end)

				it("should have positive interval", function()
					assert.is_number(spinners[name].interval, name .. " should have interval")
					assert.is_true(spinners[name].interval > 0, name .. " should have positive interval")
				end)

				it("should have string frames", function()
					for i, frame in ipairs(spinners[name].frames) do
						assert.is_string(frame, name .. " frame " .. i .. " should be a string")
					end
				end)
			end)
		end
	end)

	describe("spinner intervals", function()
		it("dots should have 80ms interval", function()
			assert.equals(80, spinners.dots.interval)
		end)

		it("line should have 130ms interval", function()
			assert.equals(130, spinners.line.interval)
		end)

		it("simpleDots should have 400ms interval", function()
			assert.equals(400, spinners.simpleDots.interval)
		end)

		it("star should have 70ms interval", function()
			assert.equals(70, spinners.star.interval)
		end)
	end)

	describe("spinner frame counts", function()
		it("dots should have 10 frames", function()
			assert.equals(10, #spinners.dots.frames)
		end)

		it("line should have 4 frames", function()
			assert.equals(4, #spinners.line.frames)
		end)

		it("arrow should have 8 frames", function()
			assert.equals(8, #spinners.arrow.frames)
		end)
	end)
end)
