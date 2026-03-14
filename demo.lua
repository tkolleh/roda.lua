#!/usr/bin/env lua
--- roda.lua demo script
--- Run with: lua demo.lua (from project root)
--- Record with: vhs demo.tape

-- Add local lua path for running from project root
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local roda = require("roda")
local system = require("system")

--- Spin for a given duration (in seconds)
--- This is required because Lua is single-threaded - we must
--- manually call :spin() in a loop to animate the frames.
---@param spinner table Spinner instance
---@param duration number Duration in seconds
local function spin_for(spinner, duration)
	local start = system.gettime()
	while (system.gettime() - start) < duration do
		spinner:spin()
		system.sleep(0.05) -- ~20 FPS
	end
end

print("")
print("  🎡 roda.lua - Elegant terminal spinners for Lua")
print("")

-- Demo 1: Basic spinner with success
local s1 = roda("Installing dependencies..."):start()
spin_for(s1, 1.8)
s1:succeed("Dependencies installed!")

system.sleep(0.5)

-- Demo 2: Different spinner style with failure
local s2 = roda({
	text = "Connecting to database...",
	spinner = "dots2",
	color = "yellow",
}):start()
spin_for(s2, 1.8)
s2:fail("Connection refused!")

system.sleep(0.5)

-- Demo 3: Warning state
local s3 = roda({
	text = "Validating configuration...",
	spinner = "arc",
	color = "cyan",
}):start()
spin_for(s3, 1.5)
s3:warn("Using deprecated options")

system.sleep(0.5)

-- Demo 4: Info state
local s4 = roda("Checking cache..."):start()
spin_for(s4, 1.2)
s4:info("Using cached response")

system.sleep(0.5)

-- Demo 5: Dynamic text updates with progress
local s5 = roda({
	text = "Processing files...",
	spinner = "bouncingBar",
	color = "magenta",
}):start()

for i = 1, 5 do
	s5:setText(string.format("Processing file %d of 5...", i))
	spin_for(s5, 0.5)
end
s5:succeed("All 5 files processed!")

system.sleep(0.5)

-- Demo 6: Multiple spinner styles showcase
print("")
print("  Available spinner styles:")
print("")

local styles = { "dots", "line", "star", "bounce", "arrow" }
for _, style in ipairs(styles) do
	local s = roda({
		text = string.format('Style: "%s"', style),
		spinner = style,
		color = "green",
	}):start()
	spin_for(s, 1.2)
	s:stop()
end

print("")
print("  ✨ Learn more: luarocks.org/modules/tkolleh/roda")
print("")
