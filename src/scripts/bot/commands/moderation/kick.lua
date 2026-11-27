local json = require("json")

local embedSuccessjson = [[
{
  "content": null,
  "embeds": [
    {
      "title": ":ballot_box_with_check: %s got kicked for %s",
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
      "title": ":x: %s failed to be kicked",
      "description": "INSERT REASON WHY",
      "color": 16734296
    }
  ],
  "attachments": []
}
]]

local command = {
    Name = "kick",
    Display = "kick",
    Desc = "kicks a member",
    Permission = 2, -- for members
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
        reasonArg = {
            Name = "reason",
            Display = "Reason",
            Desc = "reason to kick the target",
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
    local reason = args.reason or "No reason provided"
    local verbose = args.verbose or false

    local success, err = pcall(function()
        guild:kickUser(member, reason)
    end)

    if success then
        if verbose then
            local embedSuccess = json.decode(embedSuccessjson)
            embedSuccess.embeds[1].title = string.format(
                embedSuccess.embeds[1].title,
                member.username,
                reason
            )
            interaction:reply(embedSuccess)
        else
            local embedSuccess = json.decode(embedSuccessjson)
            embedSuccess.embeds[1].title = string.format(
                embedSuccess.embeds[1].title,
                member.username,
                reason
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
