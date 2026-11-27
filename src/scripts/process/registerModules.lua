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

local function setupTables()
    local files = scanDir("src/scripts/bot/autorun")

    for i, v in ipairs(files) do
        local modulePath = "../bot/autorun/" ..
            v:gsub("^src/scripts/bot/autorun/", "")
            :gsub("%.lua$", "")

        local success, required = pcall(require, modulePath)

        if tam.config.CONF.debug.logging == true then
            print("loaded:", modulePath)
            print("success:", success)
            print("return type:", type(required))
            print("return output:", tostring(required))
            print("cache value:", tostring(package.loaded[modulePath]))

            if type(required) == "table" then
                pretty.prettyPrint(required)
            end
        end

        if success and type(required) == "table" then
            assert(type(required.Name) == "string", "Command is missing a valid Name: " .. modulePath)
            local name = required.Name:lower()

            if required.eventType == "dbg"
                and tam.config.CONF.debug.debugcommands == false then
                if required.Enabled == true then
                    tam.Comms.skipped[name] = modulePath
                end
            else
                if required.Enabled == true then
                    tam.Comms.succeeds[name] = modulePath
                else
                    tam.Comms.skipped[name] = modulePath
                end
            end
        else
            tam.Comms.failed[v] = {
                file = v,
                error = required
            }
        end
    end
end

-- module functs
function rsMods.init()
    setupTables()

    for name, modulePath in pairs(tam.regModules.succeeds) do
        local success, result = pcall(require, modulePath)

        if success then
            tam.regModules.registered[name] = true
        else
            tam.regModules.failed[name] = {
                file = modulePath,
                error = result
            }

            tam.regModules.succeeds[name] = nil
            print("failed " .. name .. ": " .. tostring(result))
        end
    end
end

return rsMods
