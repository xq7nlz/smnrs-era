--- @class GuildBossDefenderTeamInBound
GuildBossDefenderTeamInBound = Class(GuildBossDefenderTeamInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function GuildBossDefenderTeamInBound:Ctor(buffer)
    --- @type number
    self.bossId = buffer:GetByte()
    --- @type PredefineTeamData
    self.predefineTeam = PredefineTeamData.CreateByBuffer(buffer)
    --- @type BossStatisticsInBound
    self.bossStatisticsInBound = BossStatisticsInBound(buffer)
end