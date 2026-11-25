local tam = _G.tam

local command = {
    Name = "test_perm",
    Display = "test perm",
    Desc = "Tests permission check",
    Permission = 8,
    CommType = "dbg",
    Enabled = true,
    CommSide = "slash", -- slash user message

    args = {}           -- contains arguments
}

function command.init(interaction)
    interaction:reply("if you have no admin permission this test failed")
end

return command
