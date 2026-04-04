-- luacheck configuration for roda.lua
-- Treat all warnings as errors by default
-- but ignore some stylistic warnings

ignore = {
    "212", -- deep nesting
    "213", -- long line (over 120 chars)
    "211", -- line contains only whitespace
    "111", -- setting non-standard global variable
    "112", -- mutating non-standard global variable
    "113", -- accessing undefined variable
    "421", -- variable defined but not used (handled by unused argument detection)
}

-- Files to check
files = {
    "**/*.lua",
    "!**/_spec.lua", -- exclude test files from some checks
}

-- Global variables that are allowed
globals = {
    "arg", -- command line arguments
    "io",
    "package",
    "string",
    "table",
    "os",
    "debug",
    "math",
    "coroutine",
    "utf8",
    "jit",
    "bit",
    "bit32",
    "_G",
    "_VERSION",
    "require",
    "setmetatable",
    "getmetatable",
    "pairs",
    "ipairs",
    "next",
    "type",
    "tostring",
    "tonumber",
    "assert",
    "error",
    "pcall",
    "xpcall",
    "rawget",
    "rawset",
    "rawequal",
    "select",
    "unpack",
    "print",
    "collectgarbage",
    "dofile",
    "load",
    "loadfile",
    "loadstring",
    "module",
    "setfenv",
    "getfenv",
    "newproxy",
    "spawn",
    "uv", -- luv library
    "busted", -- test framework
    "describe",
    "it",
    "before_each",
    "after_each",
    "setup",
    "teardown",
    "pending",
    "assert",
    "mock",
    "stub",
    "spy",
}

-- Maximum line length
max_line_length = 120

-- Maximum number of consecutive empty lines
max_empty_lines = 2

-- Allow unused arguments that start with underscore
allow_unused = {"^_"} -- matches `_` and `_err` etc.

-- Allow unused loop variables
unused_args = false

-- Check globals defined in other modules
check_globals = false
