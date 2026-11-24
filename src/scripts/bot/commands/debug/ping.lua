local tam = _G.tam

local command = {
    Name = "ping",
    Display = "ping",
    Desc = "pong!",
    Permission = 0,     -- for members
    Enabled = true,
    CommSide = "slash", -- slash user message

    args = {}           -- contains arguments
}

function command.init(interaction)
    interaction:reply("pong!")
end

return command
