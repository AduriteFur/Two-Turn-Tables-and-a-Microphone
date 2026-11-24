--// NAME: main.lua
--// DESC: a script that runs the bot
--// AUTHOR: AduriteFur
--// Note: i fucking hate require and i hope i neer have to deal with the thing being so fucking picky

_G.tam = {}
local tam = _G.tam

-- shitass fix idk
getfenv(0).require = require
package.path = package.path
    .. ";./deps/share/lua/5.5/?.lua"
    .. ";./deps/share/lua/5.5/?/init.lua"

-- modules
local discordia = require("discordia")
local tinytoml = require("tinytoml")
local pretty = require("pretty-print")
local rsComms = require("./process/registerCommands")
local globalAssign = require("./utils/templates/globalAssign")
tam.slash = require("discordia-slash").util.tools()

-- variables
tam.client = discordia.Client():useApplicationCommands()
tam.config = tinytoml.parse("src/config/bot.toml")
local tokens = tinytoml.parse("src/config/tokens.toml")

print("Starting up [" ..
    tam.config.bot.name ..
    " v" ..
    tam.config.bot.META.major ..
    "." .. tam.config.bot.META.minor .. "." .. tam.config.bot.META.hotfix .. " " .. tam.config.bot.META.codename .. "]")

tam.client:on('ready', function()
    print('Logged in as ' .. tam.client.user.username)
    rsComms.init()
end)

print("Attempting to log in")
tam.client:run("Bot " .. tokens.bot.token)
