--- roda/util.lua
--- @author TJ Kolleh
--- @license EUPL-1.2

local M = {}

--- Bracket pattern - Derived from Haskell's `Control.Exception.bracket`.
--- This uses Continuation-Passing Style (CPS) to handle async operations.
---
--- Creates a reusable bracket for asynchronous resource lifecycles.
--- @param acquire function Function to acquire the resource
--- @param release function Function to release the resource
--- @return function A function that takes a `use` function and returns a continuation
function M.bracket(acquire, release)
	return function(use)
		return function(on_complete)
			local resource = acquire()
			local released = false

			local function safe_release(...)
				if released then
					return
				end
				released = true
				release(resource)
				if on_complete then
					on_complete(...)
				end
			end

			local success, err = pcall(use, resource, safe_release)
			if not success then
				safe_release()
				error(err, 0)
			end
		end
	end
end

return M
