local command = {
    Name = "christmas_just_a_week_away_week",
    Display = "christmas_just_a_week_away_week",
    Desc = "woohoo! im so happy about this information",
    Permission = 0,     -- for members
    Enabled = true,
    CommSide = "slash", -- slash user message

    args = {}           -- contains arguments
}

function command.init(interaction)
    local date = os.date("!*t") -- UTC

    if date.month == 12 and date.day == 17 then
        interaction:reply({
            content = "",
            file = "src/assets/media/video/christmas.webm"
        })
    else
        interaction:reply("nope please wait until the 17th of december")
    end
end

return command
