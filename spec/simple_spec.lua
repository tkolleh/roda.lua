---@diagnostic disable: undefined-global
local roda = require("roda")

roda.new("Sleeping..."):execute("sleep", { "2" })(print)
roda.run()
