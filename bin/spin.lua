#!/usr/bin/env -S lx lua
--- roda CLI entry point
-- Parses command-line arguments and runs a spinner for the given command.

-- Add local path for development
package.path = "./lua/?.lua;./lua/?/init.lua;" .. package.path
package.cpath = "./.build/?.so;" .. package.cpath

local argp = require("roda.argp")
local roda = require("roda")

local parser = argp:new({
    name = "roda",
    description = "Elegant terminal spinners for Lua. Wraps commands with visual feedback.",
    epilog = "If no command is provided, roda will exit with status 0.",
})

parser:options({
    {
        short = "t",
        long = "title",
        description = "Text to display next to the spinner",
        type = "string",
        count_params = 1,
        dest = "title",
    },
    {
        long = "spinner",
        description = "Spinner style to use (e.g., dots, line, arc)",
        type = "string",
        count_params = 1,
        dest = "spinner",
    },
    {
        long = "show-output",
        description = "Display the command's stdout/stderr after it finishes",
        type = "boolean",
        count_params = 0,
        dest = "show_output",
    },
    {
        short = "c",
        long = "color",
        description = "Color of the spinner (e.g., cyan, green, yellow)",
        type = "string",
        count_params = 1,
        dest = "color",
    },
    {
        long = "prefix-text",
        description = "Text before spinner",
        type = "string",
        count_params = 1,
        dest = "prefix_text",
    },
    {
        long = "suffix-text",
        description = "Text after spinner text",
        type = "string",
        count_params = 1,
        dest = "suffix_text",
    },
    {
        short = "h",
        long = "help",
        description = "Show this help message",
        type = "boolean",
        count_params = 0,
        dest = "help",
    },
})

local function main(...)
    local args = { ... }
    if #args == 0 then
        -- No arguments, exit 0 as per test expectation
        os.exit(0)
    end

    local parsed, err = pcall(function()
        return parser:parse(args)
    end)

    if not parsed then
        io.stderr:write("error: " .. tostring(err) .. "\n")
        os.exit(1)
    end

    local options = err -- result from pcall

    if options.help then
        parser:print_system_help()
        os.exit(0)
    end

    -- Find the '--' separator
    local separator_index = nil
    for i, arg in ipairs(args) do
        if arg == "--" then
            separator_index = i
            break
        end
    end

    local command_args = {}
    if separator_index then
        for i = separator_index + 1, #args do
            table.insert(command_args, args[i])
        end
    end

    -- Build spinner options
    local spinner_opts = {}
    if options.title then
        spinner_opts.text = options.title
    end
    if options.spinner then
        spinner_opts.spinner = options.spinner
    end
    if options.color then
        spinner_opts.color = options.color
    end
    if options.prefix_text then
        spinner_opts.prefixText = options.prefix_text
    end
    if options.suffix_text then
        spinner_opts.suffixText = options.suffix_text
    end

    local spinner = roda(spinner_opts)

    if #command_args == 0 then
        -- No command to execute, just exit (test 6)
        os.exit(0)
    end

    local command = command_args[1]
    local cmd_args = {}
    for i = 2, #command_args do
        table.insert(cmd_args, command_args[i])
    end

    spinner:execute(command, cmd_args)(function(exit_code, output)
        if options.show_output and output and #output > 0 then
            io.stdout:write(output)
            io.stdout:flush()
        end
        os.exit(exit_code)
    end)

    roda.run()
end

main(...)