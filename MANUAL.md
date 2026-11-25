# Two Turn Tables and a Microphone // TAM / TTAM // [MANUAL]

## Clarification of stuff
src/scripts/bot/autorun is for stuff that run automatically usable for stuff like binding something to client events
you should not put commands into autorun as they do not run or get picked up by registerCommands.lua

use src/scripts/bot/commands for the commands
also edit bot.toml and add your own tokens to tokens.toml theres a tokens.example.toml file that is an example for this

## Structures
for commands they are infact modules look at avatar.lua for an example of advanced commands and look at ping.lua for samples
