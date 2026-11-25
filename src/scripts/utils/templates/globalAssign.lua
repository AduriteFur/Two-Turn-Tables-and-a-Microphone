--// NAME: globalAssign.lua
--// DESC: a script that legit only does is add shit to the global _G.tam
--// AUTHOR: AduriteFur i guess?
--// Notes: i did not bother writing this so i lwk took it from somewhere

local tam = _G.tam
local wtv = {}

tam.Permissions = {
    CREATE_INSTANT_INVITE = "1",
    KICK_MEMBERS = "2",
    BAN_MEMBERS = "4",
    ADMINISTRATOR = "8",
    MANAGE_CHANNELS = "16",
    MANAGE_GUILD = "32",
    ADD_REACTIONS = "64",
    VIEW_AUDIT_LOG = "128",
    PRIORITY_SPEAKER = "256",
    STREAM = "512",
    VIEW_CHANNEL = "1024",
    SEND_MESSAGES = "2048",
    SEND_TTS_MESSAGES = "4096",
    MANAGE_MESSAGES = "8192",
    EMBED_LINKS = "16384",
    ATTACH_FILES = "32768",
    READ_MESSAGE_HISTORY = "65536",
    MENTION_EVERYONE = "131072",
    USE_EXTERNAL_EMOJIS = "262144",
    VIEW_GUILD_INSIGHTS = "524288",
    CONNECT = "1048576",
    SPEAK = "2097152",
    MUTE_MEMBERS = "4194304",
    DEAFEN_MEMBERS = "8388608",
    MOVE_MEMBERS = "16777216",
    USE_VAD = "33554432",
    CHANGE_NICKNAME = "67108864",
    MANAGE_NICKNAMES = "134217728",
    MANAGE_ROLES = "268435456",
    MANAGE_WEBHOOKS = "536870912",
    MANAGE_EMOJIS_AND_STICKERS = "1073741824",
    USE_APPLICATION_COMMANDS = "2147483648",
    REQUEST_TO_SPEAK = "4294967296",
    MANAGE_EVENTS = "8589934592",
    MANAGE_THREADS = "17179869184",
    CREATE_PUBLIC_THREADS = "34359738368",
    CREATE_PRIVATE_THREADS = "68719476736",
    USE_EXTERNAL_STICKERS = "137438953472",
    SEND_MESSAGES_IN_THREADS = "274877906944",
    USE_EMBEDDED_ACTIVITIES = "549755813888",
    MODERATE_MEMBERS = "1099511627776"
}

tam.Enums = {
    ApplicationCommandType = {
        CHAT_INPUT = 1,
        USER = 2,
        MESSAGE = 3,
        PRIMARY_ENTRY_POINT = 4
    },

    ApplicationCommandOptionType = {
        SUB_COMMAND = 1,
        SUB_COMMAND_GROUP = 2,
        STRING = 3,
        INTEGER = 4,
        BOOLEAN = 5,
        USER = 6,
        CHANNEL = 7,
        ROLE = 8,
        MENTIONABLE = 9,
        NUMBER = 10,
        ATTACHMENT = 11
    },

    InteractionType = {
        PING = 1,
        APPLICATION_COMMAND = 2,
        MESSAGE_COMPONENT = 3,
        APPLICATION_COMMAND_AUTOCOMPLETE = 4,
        MODAL_SUBMIT = 5
    },

    InteractionContextType = {
        GUILD = 0,
        BOT_DM = 1,
        PRIVATE_CHANNEL = 2
    },

    InteractionResponseType = {
        PONG = 1,
        CHANNEL_MESSAGE_WITH_SOURCE = 4,
        DEFERRED_CHANNEL_MESSAGE_WITH_SOURCE = 5,
        DEFERRED_UPDATE_MESSAGE = 6,
        UPDATE_MESSAGE = 7,
        APPLICATION_COMMAND_AUTOCOMPLETE_RESULT = 8,
        MODAL = 9,
        PREMIUM_REQUIRED = 10,
        LAUNCH_ACTIVITY = 12
    },

    ChannelType = {
        GUILD_TEXT = 0,
        DM = 1,
        GUILD_VOICE = 2,
        GROUP_DM = 3,
        GUILD_CATEGORY = 4,
        GUILD_ANNOUNCEMENT = 5,
        ANNOUNCEMENT_THREAD = 10,
        PUBLIC_THREAD = 11,
        PRIVATE_THREAD = 12,
        GUILD_STAGE_VOICE = 13,
        GUILD_DIRECTORY = 14,
        GUILD_FORUM = 15,
        GUILD_MEDIA = 16
    },

    ButtonStyle = {
        PRIMARY = 1,
        SECONDARY = 2,
        SUCCESS = 3,
        DANGER = 4,
        LINK = 5,
        PREMIUM = 6
    },

    ComponentType = {
        ACTION_ROW = 1,
        BUTTON = 2,
        STRING_SELECT = 3,
        TEXT_INPUT = 4,
        USER_SELECT = 5,
        ROLE_SELECT = 6,
        MENTIONABLE_SELECT = 7,
        CHANNEL_SELECT = 8,
        SECTION = 9,
        TEXT_DISPLAY = 10,
        THUMBNAIL = 11,
        MEDIA_GALLERY = 12,
        FILE = 13,
        SEPARATOR = 14,
        CONTAINER = 17
    },

    TextInputStyle = {
        SHORT = 1,
        PARAGRAPH = 2
    },

    PermissionOverwriteType = {
        ROLE = 0,
        MEMBER = 1
    },

    InstallationType = {
        GUILD_INSTALL = 0,
        USER_INSTALL = 1
    },

    VideoQualityMode = {
        AUTO = 1,
        FULL = 2
    },

    WebhookType = {
        INCOMING = 1,
        CHANNEL_FOLLOWER = 2,
        APPLICATION = 3
    },

    ArgumentType = {
        SUB_COMMAND = 1,
        SUB_COMMAND_GROUP = 2,
        STRING = 3,
        INTEGER = 4,
        BOOLEAN = 5,
        USER = 6,
        CHANNEL = 7,
        ROLE = 8,
        MENTIONABLE = 9,
        NUMBER = 10,
        ATTACHMENT = 11
    }
}

return wtv
