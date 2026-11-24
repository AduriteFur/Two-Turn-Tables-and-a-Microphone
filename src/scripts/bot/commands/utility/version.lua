local command = {
    Name = "version",
    Display = "version",
    Desc = "shows the version",
    Permission = 0, -- for members
    Enabled = true,
    CommType = "dbg",
    CommSide = "slash",

    args = {} -- contains arguments
}

function command.init(interaction)
    interaction:reply(tam.config.bot.name ..
        " v" ..
        tam.config.bot.META.major ..
        "." .. tam.config.bot.META.minor .. "." .. tam.config.bot.META.hotfix .. " " .. tam.config.bot.META.codename)
end

return command
