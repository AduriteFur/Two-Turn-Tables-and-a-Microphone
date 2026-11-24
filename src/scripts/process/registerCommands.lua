--// NAME: registerCommands.lua
--// DESC: a module made to register commands with discordia slash
--// AUTHOR: AduriteFur
--// Notes: this is fucking torture to write

local tam = _G.tam

local rsComms = {}
tam.Comms = {
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

-- functs
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
    local files = scanDir("src/scripts/bot/commands")

    for i, v in ipairs(files) do
        local modulePath = "../bot/commands/" ..
            v:gsub("^src/scripts/bot/commands/", "")
            :gsub("%.lua$", "")

        local success, required = pcall(require, modulePath)
        print("loaded:", modulePath)
        print("returned:", type(required))

        if type(required) == "table" then
            pretty.prettyPrint(required)
        end

        if success then
            local name = required.Name:lower()

            if required.CommType == "dbg"
                and tam.config.CONF.debug.debugcommands == false then
                tam.Comms.skipped[name] = modulePath
            else
                tam.Comms.succeeds[name] = modulePath
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
function rsComms.init()
    local existing = tam.client:getGlobalApplicationCommands()
    setupTables()

    for id, command in pairs(existing) do
        local name = command[3]:lower()

        if not tam.Comms.succeeds[name] then
            tam.client:deleteGlobalApplicationCommand(id)
            print("Cleaned up " .. name)
        end
    end

    for name, modulePath in pairs(tam.Comms.succeeds) do
        local module = require(modulePath)

        local slashCommand = tam.slash.slashCommand(
            module.Name,
            module.Desc
        )

        tam.client:createGlobalApplicationCommand(slashCommand)
        tam.Comms.registered[name] = true
    end

    tam.client:on("slashCommand", function(interaction, command, args)
        local name = (command.Name or command.name):lower()
        local modulePath = tam.Comms.succeeds[name]

        if not modulePath then return end

        local module = require(modulePath)
        module.init(interaction, command, args)
    end)
end

return rsComms
