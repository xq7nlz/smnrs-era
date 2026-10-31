require "lua.client.data.Guild.GuildLevelUnit"

--- @class GuildLevel
GuildLevel = Class(GuildLevel)

--- @param tableData {level, exp, max_member, max_sub_leader, max_check_in_per_day, max_donate_per_day, max_donate_per_member_per_day}
function GuildLevel:Ctor(tableData)
    --- @type Dictionary
    self.guildLevelUnitDict = nil

    self:SetData(tableData)
end

--- @param tableData {level, exp, max_member, max_sub_leader, max_check_in_per_day, max_donate_per_day, max_donate_per_member_per_day}
function GuildLevel:SetData(tableData)
    self.guildLevelUnitDict = Dictionary()
    for i = 1, #tableData do
        local level = tonumber(tableData[i].level)
        local guildLevelUnit = GuildLevelUnit(tableData[i])
        self.guildLevelUnitDict:Add(level, guildLevelUnit)
    end
end

--- @return GuildLevelUnit
--- @param level number
function GuildLevel:GetGuildLevelUnitConfig(level)
    return self.guildLevelUnitDict:Get(level)
end

function GuildLevel:GetGuildMaxLevel()
    return self.guildLevelUnitDict:Count()
end