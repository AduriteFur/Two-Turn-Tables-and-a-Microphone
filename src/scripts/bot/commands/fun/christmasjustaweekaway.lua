local tam = _G.tam

local command = {
    Name = "christmas_just_a_week_away",
    Display = "christmas_just_a_week_away",
    Desc = "christmas is in a week woohoo!",
    Permission = 0,     -- for members
    Enabled = true,
    CommSide = "slash", -- slash user message

    args = {}           -- contains arguments
}

function command.init(interaction)
    local date = os.date("!*t") -- UTC

    if date.year == 2026 and date.month == 12 and date.day == 17 then
        interaction:reply({
            content = "",
            file = "src/assets/media/video/christmas.webm"
        })
    else
        interaction:reply("nope")
    end
end

return command
