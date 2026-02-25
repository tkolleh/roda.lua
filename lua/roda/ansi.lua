--- roda/ansi.lua - ANSI escape code utilities
--- @module roda.ansi
--- @author TJ Kolleh
--- @license EUPL-1.2

local M = {}

-------------------------------------------------------------------------------
-- Cursor control
-------------------------------------------------------------------------------
M.hide_cursor = "\27[?25l"
M.show_cursor = "\27[?25h"
M.clear_line = "\27[2K"
M.move_to_col_1 = "\27[G"
M.move_up = "\27[A"

-------------------------------------------------------------------------------
-- Text formatting
-------------------------------------------------------------------------------
M.reset = "\27[0m"
M.bold = "\27[1m"

-------------------------------------------------------------------------------
-- Foreground colors
-------------------------------------------------------------------------------
M.colors = {
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

-------------------------------------------------------------------------------
-- Helper functions
-------------------------------------------------------------------------------

--- Get ANSI color code by name
---@param color string|boolean|nil Color name, false to disable, or nil for default
---@return string ANSI escape sequence (empty string if disabled)
function M.get_color(color)
  if type(color) == "boolean" and not color then
    return ""
  end
  return M.colors[color] or M.colors.cyan
end

--- Check if the given stream supports ANSI colors
---@param stream file*|nil The stream to check (defaults to io.stderr)
---@return boolean True if colors are supported
function M.supports_color(stream)
  stream = stream or io.stderr
  -- Basic check: assume TTY supports color
  -- In practice, you'd check isatty() but Lua doesn't have this built-in
  return true
end

return M
