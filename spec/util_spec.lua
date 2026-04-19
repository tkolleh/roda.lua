---@diagnostic disable: undefined-global
local fp = require("roda.util")

describe("roda.util", function()
	describe("bracket", function()
		it("should acquire resource and pass it to use", function()
			local acquired = false
			local resource_value = "test-resource"
			local received_resource = nil

			local bracket = fp.bracket(function()
				acquired = true
				return resource_value
			end, function() end)

			local use_fn = bracket(function(resource, done)
				received_resource = resource
				done()
			end)

			use_fn(function() end)

			assert.is_true(acquired)
			assert.equals(resource_value, received_resource)
		end)

		it("should release resource via release callback", function()
			local released = false
			local released_resource = nil

			local bracket = fp.bracket(function()
				return "res"
			end, function(r)
				released = true
				released_resource = r
			end)

			local use_fn = bracket(function(resource, done)
				done("result")
			end)

			use_fn(function() end)

			assert.is_true(released)
			assert.equals("res", released_resource)
		end)

		it("should pass callback values to on_complete", function()
			local on_complete_result = nil

			local bracket = fp.bracket(function()
				return "res"
			end, function() end)

			local use_fn = bracket(function(resource, done)
				done("value1", "value2")
			end)

			use_fn(function(...)
				on_complete_result = { ... }
			end)

			assert.equals("value1", on_complete_result[1])
			assert.equals("value2", on_complete_result[2])
		end)

		it("should call release before on_complete", function()
			local call_order = {}

			local bracket = fp.bracket(function()
				return "res"
			end, function()
				table.insert(call_order, "release")
			end)

			local use_fn = bracket(function(resource, done)
				done()
			end)

			use_fn(function()
				table.insert(call_order, "on_complete")
			end)

			assert.equals("release", call_order[1])
			assert.equals("on_complete", call_order[2])
		end)

		it("should not call on_complete when it is nil", function()
			local bracket = fp.bracket(function()
				return "res"
			end, function() end)

			local use_fn = bracket(function(resource, done)
				done("result")
			end)

			assert.has_no.errors(function()
				use_fn(nil)
			end)
		end)

		it("should call release only once even if done is called multiple times", function()
			local release_count = 0
			local bracket = fp.bracket(function()
				return "res"
			end, function()
				release_count = release_count + 1
			end)

			local use_fn = bracket(function(resource, done)
				done()
				done()
				done()
			end)

			use_fn(function() end)

			assert.equals(1, release_count)
		end)

		it("should call release and re-throw if use throws a synchronous error", function()
			local released = false
			local bracket = fp.bracket(function()
				return "res"
			end, function()
				released = true
			end)

			local use_fn = bracket(function(resource, done)
				error("synchronous error")
			end)

			assert.has_error(function()
				use_fn(function() end)
			end, "synchronous error")

			assert.is_true(released)
		end)
	end)
end)
