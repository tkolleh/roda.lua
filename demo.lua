#!/usr/bin/env lua
--- roda.lua demo script
--- Run with: lua demo.lua (from project root)
--- Record with: vhs demo.tape

-- Add local lua path for running from project root
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path

local roda = require("roda")
local system = require("system")

print("")
print("  🎡 roda.lua - Elegant terminal spinners for Lua")
print("  ─────────────────────────────────────────────────")
print("")

system.sleep(1)

-- Demo 1: Basic spinner with success
local s1 = roda("Installing dependencies..."):start()
system.sleep(2)
s1:succeed("Dependencies installed!")

system.sleep(0.8)

-- Demo 2: Different spinner style with failure
local s2 = roda({
	text = "Connecting to database...",
	spinner = "dots2",
	color = "yellow",
}):start()
system.sleep(1.8)
s2:fail("Connection refused!")

system.sleep(0.8)

-- Demo 3: Warning state
local s3 = roda({
	text = "Validating configuration...",
	spinner = "arc",
	color = "cyan",
}):start()
system.sleep(1.5)
s3:warn("Using deprecated options")

system.sleep(0.8)

-- Demo 4: Info state
local s4 = roda("Checking cache..."):start()
system.sleep(1.2)
s4:info("Using cached response")

system.sleep(0.8)

-- Demo 5: Dynamic text updates with progress
local s5 = roda({
	text = "Processing files...",
	spinner = "bouncingBar",
	color = "magenta",
}):start()

for i = 1, 5 do
	s5:setText(string.format("Processing file %d of 5...", i))
	system.sleep(0.7)
end
s5:succeed("All 5 files processed!")

system.sleep(0.8)

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
	system.sleep(1.5)
	s:stop()
end

print("")
print("  ✨ Learn more: https://luarocks.org/modules/tkolleh/roda")
print("")
