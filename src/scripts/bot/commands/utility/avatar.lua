local command = {
    Name = "avatar",
    Display = "avatar",
    Desc = "returns a user's avatar",
    Permission = 0, -- for members
    Enabled = true,
    --CommType = "dbg",
    CommSide = "slash",

    args = {
        memberArg = {
            Name = "member",
            Display = "Member",
            Desc = "The member whose avatar to retrieve",
            Type = _G.tam.Enums.ArgumentType.USER,
            Required = true
        },
        sizeArg = {
            Name = "size",
            Display = "Size",
            Desc = "The avatar image size",
            Type = _G.tam.Enums.ArgumentType.INTEGER,
            Required = false,
            MinValue = 16,
            MaxValue = 256
        }
    }
}

function command.init(interaction, l, args)
    local member = args.member
    local size = args.size or 256

    interaction:reply(member:getAvatarURL(size), true)
end

return command
