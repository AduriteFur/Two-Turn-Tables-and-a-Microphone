local json = require("json")

local embedSuccessjson = [[
{
  "content": null,
  "embeds": [
    {
      "title": ":ballot_box_with_check: %s got banned for %s",
      "color": 5832543
    }
  ],
  "attachments": []
}
]]

local embedFailjson = [[
{
  "content": null,
  "embeds": [
    {
      "title": ":x: %s failed to be banned",
      "description": "INSERT REASON WHY",
      "color": 16734296
    }
  ],
  "attachments": []
}
]]

local command = {
    Name = "ban",
    Display = "ban",
    Desc = "bans a member",
    Permission = 4, -- for members
    Enabled = true,
    --CommType = "dbg",
    CommSide = "slash",

    args = {
        memberArg = {
            Name = "member",
            Display = "Member",
            Desc = "target",
            Type = _G.tam.Enums.ArgumentType.USER,
            Required = true
        },
        timeArg = {
            Name = "time",
            Display = "Time",
            Desc = "time for the person to get unbanned in days (use -1 for permaBans)",
            Type = _G.tam.Enums.ArgumentType.INTEGER,
            Required = true,
            MinValue = -1,
            MaxValue = 30
        },
        reasonArg = {
            Name = "reason",
            Display = "Reason",
            Desc = "reason to ban the target",
            Type = _G.tam.Enums.ArgumentType.STRING,
            Required = false,
        },
        verboseArg = {
            Name = "verbose",
            Display = "Verbose",
            Desc = "shows an embed or not",
            Type = _G.tam.Enums.ArgumentType.BOOLEAN,
            Required = false,
        },
    }
}

function command.init(interaction, l, args)
    local guild = interaction.guild
    local member = args.member
    local time = args.time
    local reason = args.reason or "No reason provided"
    local verbose = args.verbose or false

    local success, err = pcall(function()
        guild:banUser(member, reason, 0)
    end)

    if success then
        if verbose then
            local embedSuccess = json.decode(embedSuccessjson)
            embedSuccess.embeds[1].title = string.format(
                embedSuccess.embeds[1].title,
                member.username,
                time == -1 and "permanently" or (time .. " days")
            )
            interaction:reply(embedSuccess)
        else
            local embedSuccess = json.decode(embedSuccessjson)
            embedSuccess.embeds[1].title = string.format(
                embedSuccess.embeds[1].title,
                member.username,
                time == -1 and "permanently" or (time .. " days")
            )
            interaction:reply(embedSuccess, true)
        end
    else
        local embedFail = json.decode(embedFailjson)
        embedFail.embeds[1].title = string.format(
            embedFail.embeds[1].title,
            member.username
        )

        embedFail.embeds[1].description = tostring(err)
        interaction:reply(embedFail)
    end
end

return command
