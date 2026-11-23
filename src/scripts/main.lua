_G.tam = {}
local tam = _G.tam

-- this looks ugly as balls
package.path = package.path .. ";./deps/share/lua/5.5/?.lua;./deps/share/lua/5.5/?/init.lua"

local discordia = require('discordia')
local tinytoml = require("tinytoml")
local pretty = require("pretty-print")
tam.client = discordia.Client()
tam.config = tinytoml.parse("src/config/bot.toml")
local tokens = tinytoml.parse("src/config/tokens.toml")

print("Starting up as " ..
    tam.config.bot.name ..
    " v" ..
    tam.config.bot.META.major ..
    "." .. tam.config.bot.META.minor .. "." .. tam.config.bot.META.hotfix .. " " .. tam.config.bot.META.codename)
