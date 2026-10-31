--- @class UIGuildDailyBossModel : UIBaseModel
UIGuildDailyBossModel = Class(UIGuildDailyBossModel, UIBaseModel)

--- @return void
function UIGuildDailyBossModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIGuildDailyBoss, "guild_daily_boss")
    --- @type UIPopupType
    self.type = UIPopupType.NO_BLUR_POPUP
    --- @type number
    self.selfDamage = 0
    --- @type number
    self.selfRank = 0
    --- @type number
    self.currentTotalGuildDamage = 0

    --- @type number
    self.currentBossTier = 1
    --- @type number
    self.highestBossTier = 1
end

--- @param dataInBound GuildBossDataInBound
function UIGuildDailyBossModel:SetGuildBossDataInBound(dataInBound)
    self.currentTotalGuildDamage = 0
    self.selfDamage = 0
    if dataInBound.isHaveGuildBoss == true then
        local bossStatistics = dataInBound.guildBoss.bossStatisticsInBound
        for i = 1, bossStatistics.listBossStatistics:Count() do
            --- @type BossStatistics
            local statistics = bossStatistics.listBossStatistics:Get(i)
            self.currentTotalGuildDamage = self.currentTotalGuildDamage + statistics.damage
            if statistics.playerId == PlayerSettingData.playerId then
                self.selfDamage = statistics.damage
                self.selfRank = i
            end
        end
    end
end

--- @return BattleTeamInfo
--- @param guildBossDataInBound GuildBossDataInBound
function UIGuildDailyBossModel:GetDefenderBattleTeamInfo(guildBossDataInBound)
    return DefenderTeamData.GetBattleTeamInfoByPredefineTeam(guildBossDataInBound.guildBoss.predefineTeam)
end

--- @return GuildMemberInBound
--- @param playerId number
function UIGuildDailyBossModel:FindGuildMemberById(playerId)
    local listMember = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).guildInfo.listGuildMember
    for i = 1, listMember:Count() do
        --- @type GuildMemberInBound
        local member = listMember:Get(i)
        if member.playerId == playerId then
            return member
        end
    end
    return nil
end

