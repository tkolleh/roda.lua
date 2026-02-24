#!/usr/bin/env lua
--- Demo script for Roda terminal spinner library
--- Run this script to see all features in action

local system = require("system")

-- Add local path for development
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
local roda = require("roda")

print("\n  Roda - Elegant terminal spinners for Lua\n")
print("  ==========================================\n")

-- Demo 1: Basic usage
print("  1. Basic Usage")
local spinner = roda("Loading configuration..."):start()
system.sleep(1.5)
spinner:succeed("Configuration loaded")

system.sleep(0.5)

-- Demo 2: Different terminal states
print("\n  2. Terminal States")
spinner = roda("Connecting to server..."):start()
system.sleep(1.2)
spinner:fail("Connection failed")

system.sleep(0.5)

spinner = roda("Using cached data..."):start()
system.sleep(0.8)
spinner:warn("Cache is stale")

system.sleep(0.5)

spinner = roda("Version check..."):start()
system.sleep(0.8)
spinner:info("v2.1.0 available")

system.sleep(0.5)

-- Demo 3: Progress updates
print("\n  3. Dynamic Text Updates")
spinner = roda("Installing dependencies..."):start()
for i = 1, 5 do
  spinner:setText(string.format("Installing dependencies [%d/5]...", i))
  spinner:spin()
  system.sleep(0.6)
end
spinner:succeed("Installed 5 packages")

system.sleep(0.5)

-- Demo 4: Different spinner styles
print("\n  4. Spinner Styles")
local styles = { "dots", "line", "arc", "star" }
for _, style in ipairs(styles) do
  spinner = roda({
    text = "Spinner style: " .. style,
    spinner = style,
  }):start()
  local start_time = system.gettime()
  while system.gettime() - start_time < 1.5 do
    spinner:spin()
    system.sleep(0.08)
  end
  spinner:succeed("Style: " .. style)
  system.sleep(0.3)
end

-- Demo 5: Colors
print("\n  5. Colors")
local colors = { "cyan", "green", "yellow", "magenta" }
for _, color in ipairs(colors) do
  spinner = roda({
    text = "Color: " .. color,
    color = color,
  }):start()
  local start_time = system.gettime()
  while system.gettime() - start_time < 0.8 do
    spinner:spin()
    system.sleep(0.08)
  end
  spinner:succeed("Color: " .. color)
  system.sleep(0.2)
end

print("\n  Done!\n")
