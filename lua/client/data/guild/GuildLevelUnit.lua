--- @class GuildLevelUnit
GuildLevelUnit = Class(GuildLevelUnit)

--- @param tableData {level, exp, max_member, max_sub_leader, max_check_in_per_day, max_donate_per_day, max_donate_per_member_per_day}
function GuildLevelUnit:Ctor(tableData)
    --- @type number
    self.level = tonumber(tableData.level)
    --- @type number
    self.exp = tonumber(tableData.exp)
    --- @type number
    self.maxMember = tonumber(tableData.max_member)
    --- @type number
    self.maxSubLeader = tonumber(tableData.max_sub_leader)
    --- @type number
    self.maxCheckInPerDay = tonumber(tableData.max_check_in_per_day)
    --- @type number
    self.maxDonatePerDay = tonumber(tableData.max_donate_per_day)
    --- @type number
    self.maxDonatePerMemberPerDay = tonumber(tableData.max_donate_per_member_per_day)
end