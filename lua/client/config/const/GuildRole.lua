--- @class GuildRole
GuildRole = {
    MEMBER = 0,
    SUB_LEADER = 1,
    LEADER = 2,

    --- @param guildRole GuildRole
    --- @type string
    RoleName = function(guildRole)
        if guildRole == GuildRole.LEADER then
            return LanguageUtils.LocalizeCommon("master")
        elseif guildRole == GuildRole.SUB_LEADER then
            return LanguageUtils.LocalizeCommon("deputy")
        else
            return LanguageUtils.LocalizeCommon("member")
        end
    end,
}