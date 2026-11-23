_G.tam = {}
local tam = _G.tam

-- this looks ugly as balls
package.path = package.path .. ";./deps/share/lua/5.5/?.lua;./deps/share/lua/5.5/?/init.lua"

local discordia = require('discordia')
local tinytoml = require("tinytoml")
tam.client = discordia.Client()
