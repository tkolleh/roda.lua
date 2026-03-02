--- roda.lua - Elegant terminal spinner for Lua
--- Roda (Portuguese for "wheel") - inspired by sindresorhus/ora
---
--- @module roda
--- @author TJ Kolleh
--- @license EUPL-1.2

local system = require("system")
local ansi = require("roda.ansi")
local spinners = require("roda.spinners")
local symbols = require("roda.symbols")

local M = {}

-- Re-export submodules for advanced usage
M.ansi = ansi
M.spinners = spinners
M.symbols = symbols

-- Default spinner name
M.default_spinner = spinners.default

-------------------------------------------------------------------------------
-- Spinner class
-------------------------------------------------------------------------------

---@class Spinner
---@field private _text string
---@field private _prefix_text string
---@field private _suffix_text string
---@field private _color string|boolean
---@field private _spinner table
---@field private _interval number
---@field private _stream file*
---@field private _hide_cursor boolean
---@field private _indent number
---@field private _is_spinning boolean
---@field private _frame_index number
---@field private _last_frame_time number
local Spinner = {}
Spinner.__index = Spinner

--- Create a new spinner instance
---@param opts string|table|nil Options table or text string
---@return Spinner Spinner instance
function M.new(opts)
	if type(opts) == "string" then
		opts = { text = opts }
	end
	opts = opts or {}

	local spinner_def = opts.spinner
	if type(spinner_def) == "string" then
		spinner_def = spinners[spinner_def] or spinners[M.default_spinner]
	elseif type(spinner_def) ~= "table" then
		spinner_def = spinners[M.default_spinner]
	end

	local self = setmetatable({}, Spinner)

	self._text = opts.text or ""
	self._prefix_text = opts.prefixText or ""
	self._suffix_text = opts.suffixText or ""
	self._color = opts.color == nil and "cyan" or opts.color
	self._spinner = spinner_def
	self._interval = opts.interval or spinner_def.interval or 100
	self._stream = opts.stream or io.stderr
	self._hide_cursor = opts.hideCursor ~= false
	self._indent = opts.indent or 0
	self._is_spinning = false
	self._frame_index = 1
	self._last_frame_time = 0

	return self
end

-------------------------------------------------------------------------------
-- Text accessors
-------------------------------------------------------------------------------

--- Get the current text
---@return string
function Spinner:getText()
	return self._text
end

--- Set the text
---@param text string|nil Text to display
---@return Spinner self
function Spinner:setText(text)
	self._text = text or ""
	if self._is_spinning then
		self:render()
	end
	return self
end

--- Get prefix text
---@return string
function Spinner:getPrefixText()
	return self._prefix_text
end

--- Set prefix text
---@param text string|nil Text before spinner
---@return Spinner self
function Spinner:setPrefixText(text)
	self._prefix_text = text or ""
	return self
end

--- Get suffix text
---@return string
function Spinner:getSuffixText()
	return self._suffix_text
end

--- Set suffix text
---@param text string|nil Text after spinner text
---@return Spinner self
function Spinner:setSuffixText(text)
	self._suffix_text = text or ""
	return self
end

-------------------------------------------------------------------------------
-- Color accessors
-------------------------------------------------------------------------------

--- Get spinner color
---@return string|boolean
function Spinner:getColor()
	return self._color
end

--- Set spinner color
---@param color string|boolean Color name or false to disable
---@return Spinner self
function Spinner:setColor(color)
	self._color = color
	return self
end

-------------------------------------------------------------------------------
-- State methods
-------------------------------------------------------------------------------

--- Check if spinner is currently spinning
---@return boolean
function Spinner:isSpinning()
	return self._is_spinning
end

--- Get current frame character
---@return string
function Spinner:frame()
	local frames = self._spinner.frames
	return frames[self._frame_index]
end

-------------------------------------------------------------------------------
-- Rendering
-------------------------------------------------------------------------------

--- Clear the current line
---@return Spinner self
function Spinner:clear()
	self._stream:write(ansi.clear_line .. ansi.move_to_col_1)
	self._stream:flush()
	return self
end

--- Render the current frame
---@return Spinner self
function Spinner:render()
	if not self._is_spinning then
		return self
	end

	local now = system.gettime()
	local elapsed_ms = (now - self._last_frame_time) * 1000

	if elapsed_ms >= self._interval then
		self._frame_index = self._frame_index + 1
		if self._frame_index > #self._spinner.frames then
			self._frame_index = 1
		end
		self._last_frame_time = now
	end

	local indent = string.rep(" ", self._indent)
	local frame = self:frame()
	local color_code = ansi.get_color(self._color)
	local prefix = self._prefix_text ~= "" and (self._prefix_text .. " ") or ""
	local suffix = self._suffix_text ~= "" and (" " .. self._suffix_text) or ""

	local line = string.format(
		"%s%s%s%s%s %s%s%s",
		ansi.clear_line .. ansi.move_to_col_1,
		indent,
		prefix,
		color_code,
		frame,
		ansi.reset,
		self._text,
		suffix
	)

	self._stream:write(line)
	self._stream:flush()

	return self
end

-------------------------------------------------------------------------------
-- Control methods
-------------------------------------------------------------------------------

--- Start the spinner
---@param text string|nil Optional text to set
---@return Spinner self
function Spinner:start(text)
	if text then
		self._text = text
	end

	if self._is_spinning then
		return self
	end

	self._is_spinning = true
	self._frame_index = 1
	self._last_frame_time = system.gettime()

	if self._hide_cursor then
		self._stream:write(ansi.hide_cursor)
		self._stream:flush()
	end

	self:render()

	return self
end

--- Stop the spinner and clear
---@return Spinner self
function Spinner:stop()
	if not self._is_spinning then
		return self
	end

	self._is_spinning = false
	self:clear()

	if self._hide_cursor then
		self._stream:write(ansi.show_cursor)
		self._stream:flush()
	end

	return self
end

--- Stop the spinner and persist with a symbol and text
---@param opts table|nil Options: symbol, text, prefixText, suffixText
---@return Spinner self
function Spinner:stopAndPersist(opts)
	opts = opts or {}

	self._is_spinning = false

	local symbol = opts.symbol or " "
	local text = opts.text or self._text
	local prefix = opts.prefixText or self._prefix_text
	local suffix = opts.suffixText or self._suffix_text
	local indent = string.rep(" ", self._indent)

	local prefix_str = prefix ~= "" and (prefix .. " ") or ""
	local suffix_str = suffix ~= "" and (" " .. suffix) or ""

	local line = string.format(
		"%s%s%s%s %s%s\n",
		ansi.clear_line .. ansi.move_to_col_1,
		indent,
		prefix_str,
		symbol,
		text,
		suffix_str
	)

	self._stream:write(line)

	if self._hide_cursor then
		self._stream:write(ansi.show_cursor)
	end

	self._stream:flush()

	return self
end

--- Stop with success symbol (green checkmark)
---@param text string|nil Optional text override
---@return Spinner self
function Spinner:succeed(text)
	return self:stopAndPersist({
		symbol = ansi.colors.green .. symbols.succeed .. ansi.reset,
		text = text,
	})
end

--- Stop with failure symbol (red X)
---@param text string|nil Optional text override
---@return Spinner self
function Spinner:fail(text)
	return self:stopAndPersist({
		symbol = ansi.colors.red .. symbols.fail .. ansi.reset,
		text = text,
	})
end

--- Stop with warning symbol (yellow warning)
---@param text string|nil Optional text override
---@return Spinner self
function Spinner:warn(text)
	return self:stopAndPersist({
		symbol = ansi.colors.yellow .. symbols.warn .. ansi.reset,
		text = text,
	})
end

--- Stop with info symbol (blue info)
---@param text string|nil Optional text override
---@return Spinner self
function Spinner:info(text)
	return self:stopAndPersist({
		symbol = ansi.colors.blue .. symbols.info .. ansi.reset,
		text = text,
	})
end

--- Spin once (call in a loop for animation)
---@return Spinner self
function Spinner:spin()
	if self._is_spinning then
		self:render()
	end
	return self
end

-------------------------------------------------------------------------------
-- Module-level convenience functions
-------------------------------------------------------------------------------

--- Create and optionally start a spinner (alias for new)
---@param opts string|table Options or text
---@return Spinner Spinner instance
function M.roda(opts)
	return M.new(opts)
end

--- Wrap a function execution with a spinner
---@param opts table Options with: text, successText, failText, fn (function to execute)
---@return any Result of the function, or nil on error
---@return string|nil Error message if failed
function M.promise(opts)
	local spinner = M.new(opts)
	spinner:start()

	local success, result = pcall(opts.fn)

	if success then
		spinner:succeed(opts.successText)
		return result
	else
		spinner:fail(opts.failText or tostring(result))
		return nil, result
	end
end

-------------------------------------------------------------------------------
-- Metatable: allow calling module directly as function
-------------------------------------------------------------------------------

setmetatable(M, {
	__call = function(_, opts)
		return M.new(opts)
	end,
})

return M
