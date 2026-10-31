--- @class GuildWarRecordItemView : IconView
GuildWarRecordItemView = Class(GuildWarRecordItemView, IconView)

--- @return void
function GuildWarRecordItemView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    ---@type GuildWarRecord
    self.guildWarRecord = nil
end

--- @return void
function GuildWarRecordItemView:SetPrefabName()
    self.prefabName = 'guild_war_record'
    self.uiPoolType = UIPoolType.GuildWarRecordItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function GuildWarRecordItemView:SetConfig(transform)
    ---@type UIGuildWarDefenderLogConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonReplay.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickWatchRecord()
    end)
end

--- @return void
--- @param playerId number
--- @param guildWarRecord GuildWarRecord
function GuildWarRecordItemView:SetData(playerId, guildWarRecord, callbackWatchRecord, slotElo)
    self:DisableIconsResult()

    self.guildWarRecord = guildWarRecord
    self.callbackWatchRecord = callbackWatchRecord
    local isAttackerWin = guildWarRecord.isAttackWin
    local isAttacker = playerId == guildWarRecord.teamRecordAttack.playerId
    if isAttacker then
        self.config.textName.text = self.guildWarRecord.teamRecordDefend.playerName
        if isAttackerWin then
            self.config.iconAttackSuccess:SetActive(true)
        else
            self.config.iconAttackFailure:SetActive(true)
        end
    else
        self.config.textName.text = self.guildWarRecord.teamRecordAttack.playerName
        if isAttackerWin then
            self.config.iconMedal:SetActive(true)
            self.config.iconDefenseFailure:SetActive(true)

            self.config.textGuildWarMedalsPoint.text = tostring(-slotElo * self.guildWarRecord.medalChange)
        else
            self.config.iconDefenseSuccess:SetActive(true)
        end
    end
    local colorTextName = isAttackerWin and UIUtils.RECORD_LOSE or UIUtils.RECORD_WIN
    self.config.textName.color = colorTextName

end

function GuildWarRecordItemView:DisableIconsResult()
    self.config.iconAttackFailure:SetActive(false)
    self.config.iconAttackSuccess:SetActive(false)
    self.config.iconDefenseSuccess:SetActive(false)
    self.config.iconDefenseFailure:SetActive(false)
    self.config.iconMedal:SetActive(false)
end

--- @return void
function GuildWarRecordItemView:OnClickWatchRecord()
    ---@param seedInBound SeedInBound
    ---@param attackerTeamInfo BattleTeamInfo
    ---@param defenderTeamInfo BattleTeamInfo
    local runRecord = function(attackerTeamInfo, defenderTeamInfo, seedInBound, battleLog)
        ClientBattleData.skipForReplay = true

        ---@type RandomHelper
        local randomHelper = RandomHelper()
        randomHelper:SetSeed(seedInBound.seed)

        zg.battleMgr:RunVirtualBattle(attackerTeamInfo, defenderTeamInfo, GameMode.GUILD_WAR, randomHelper, RunMode.FASTEST, battleLog)

        if self.guildWarRecord.isAttackWin ~= (ClientBattleData.battleResult.winnerTeam == BattleConstants.ATTACKER_TEAM_ID) then
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("play_record_failed"))
        else
            zg.playerData.medalGuildWarChange = nil
            randomHelper:SetSeed(seedInBound.seed)
            zg.battleMgr:RunCalculatedBattleScene(attackerTeamInfo, defenderTeamInfo, GameMode.GUILD_WAR, randomHelper, self.callbackWatchRecord, battleLog)
        end
    end
    self.guildWarRecord:RequestGetBattleData(runRecord, SmartPoolUtils.LogicCodeNotification)
end

return GuildWarRecordItemView