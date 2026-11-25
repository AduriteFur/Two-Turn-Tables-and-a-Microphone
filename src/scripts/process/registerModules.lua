--// NAME: registerModuels.lua
--// DESC: a module made to require other modules safely and automatically via src/scripts/bot/autorun
--// AUTHOR: AduriteFur
--// Notes: prolly not gonna be torture to write due to rsComms existing but uhh this doesnt work right now

local tam = _G.tam

local rsMods = {}
tam.regModules = {
    succeeds = {},
    skipped = {},
    failed = {},
    registered = {}
}

-- modules
local fs = require("fs")
local path = require("path")
local pretty = require("pretty-print")
local timer = require("timer")

-- functions
local function scanDir(dir, files)
    files = files or {}

    local entries = fs.scandirSync(dir)

    while true do
        local name, entryType = entries()
        if not name then break end

        local fullPath = path.join(dir, name)

        if entryType == "directory" then
            scanDir(fullPath, files)
        elseif entryType == "file" and fullPath:match("%.lua$") then
            files[#files + 1] = fullPath
        end
    end

    return files
end
