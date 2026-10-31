---COMMENT_CONFIG_COMMON    require "lua.client.scene.ui.common.ArenaRecordItemConfig"

--- @class ArenaRecordItemView : IconView
ArenaRecordItemView = Class(ArenaRecordItemView, IconView)

--- @return void
function ArenaRecordItemView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    ---@type BattleRecordShortBase
    self.battleRecordShort = nil
    ---@type TeamRecordShort
    self.teamOpponent = nil
    ---@type VipIconView
    self.vipIconView = nil
    ---@type function
    self.callbackShowInfo = nil
    ---@type function
    self.callbackBattle = nil
    ---@type function
    self.callbackWatchRecord = nil
end

--- @return void
function ArenaRecordItemView:SetPrefabName()
    self.prefabName = 'arena_record_item_view'
    self.uiPoolType = UIPoolType.ArenaRecordItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaRecordItemView:SetConfig(transform)
    assert(transform)
    --- @type ArenaRecordItemConfig
    ---@type ArenaRecordItemConfig
    self.config = UIBaseConfig(transform)
    self.config.buttonBattle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBattle(self)
    end)
    self.config.buttonPlayRecord.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickWatchRecord(self)
    end
    )
end

--- @return void
function ArenaRecordItemView:InitLocalization()
    self.config.localizeScore.text = LanguageUtils.LocalizeCommon("point")
    --self.config.localizeReplay.text = LanguageUtils.LocalizeCommon("revenge")
end

--- @return void
---@param battleRecordShort BattleRecordShortBase
function ArenaRecordItemView:SetData(battleRecordShort, isNoti)
    self.battleRecordShort = battleRecordShort
    self.config.noti:SetActive(isNoti)
    local updateWinLose = function(isWin, elo)
        if isWin then
            self.config.arrowUp:SetActive(true)
            self.config.arrowDown:SetActive(false)
            self.config.textScoreValue.text = elo .. UIUtils.SetColorString(UIUtils.color2, string.format("(+%s)", battleRecordShort.eloChange))
            self.config.buttonBattle.gameObject:SetActive(false)
        else
            self.config.arrowUp:SetActive(false)
            self.config.arrowDown:SetActive(true)
            self.config.textScoreValue.text = elo .. UIUtils.SetColorString(UIUtils.color7, string.format("(-%s)", battleRecordShort.eloChange))
            if battleRecordShort:IsAttacker() then
                self.config.buttonBattle.gameObject:SetActive(false)
            else
                self.config.buttonBattle.gameObject:SetActive(self.battleRecordShort:IsRevenge() == false)
                --UIUtils.SetInteractableButton(self.config.buttonBattle, self.battleRecordShort:IsRevenge() == false)
            end

        end
    end
    self.teamOpponent = battleRecordShort:GetTeamRecordShortOpponent()
    if battleRecordShort:IsAttacker() then
        updateWinLose(battleRecordShort.isAttackWin == true, battleRecordShort.attackerElo)
        if battleRecordShort.isAttackWin then
            self.config.textWin.text = LanguageUtils.LocalizeCommon("attack_success")
            self.config.iconAttackSuccess:SetActive(true)
            self.config.iconAttackFail:SetActive(false)
            self.config.iconDefenseFail:SetActive(false)
            self.config.iconDefenseSuccess:SetActive(false)
        else
            self.config.textWin.text = LanguageUtils.LocalizeCommon("attack_fail")
            self.config.iconAttackSuccess:SetActive(false)
            self.config.iconAttackFail:SetActive(true)
            self.config.iconDefenseFail:SetActive(false)
            self.config.iconDefenseSuccess:SetActive(false)
        end
    else
        updateWinLose(battleRecordShort.isAttackWin == false, battleRecordShort.defenderElo)
        if battleRecordShort.isAttackWin then
            self.config.textWin.text = LanguageUtils.LocalizeCommon("defense_fail")
            self.config.iconAttackSuccess:SetActive(false)
            self.config.iconAttackFail:SetActive(false)
            self.config.iconDefenseFail:SetActive(true)
            self.config.iconDefenseSuccess:SetActive(false)
        else
            self.config.textWin.text = LanguageUtils.LocalizeCommon("defense_success")
            self.config.iconAttackSuccess:SetActive(false)
            self.config.iconAttackFail:SetActive(false)
            self.config.iconDefenseFail:SetActive(false)
            self.config.iconDefenseSuccess:SetActive(true)
        end
    end
    self.config.textUserName.text = self.battleRecordShort:GetName()
    self.config.textEventTimeJoin.text = TimeUtils.GetDeltaTimeAgo(zg.timeMgr:GetServerTime() - battleRecordShort.time)
    --if self.vipIconView == nil then
    --    self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.heroSlot)
    --end
    --self.vipIconView:SetData2(self.teamOpponent.playerAvatar, self.teamOpponent.playerLevel)
    --self.vipIconView:AddListener(function ()
    --    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    --    self:OnClickShowInfo()
    --end)
    if InventoryUtils.CanUseFreeTurnArena() then
        self.config.localizeReplay.text = tostring(0)
    else
        self.config.localizeReplay.text = tostring(1)
    end
end

--- @return void
function ArenaRecordItemView:OnClickShowInfo()
    if self.callbackShowInfo ~= nil then
        self.callbackShowInfo(self)
    end
end

--- @return void
function ArenaRecordItemView:OnClickBattle()
    if self.callbackBattle ~= nil then
        self.callbackBattle(self)
    end
end

--- @return void
function ArenaRecordItemView:OnClickWatchRecord()
    if self.callbackWatchRecord ~= nil then
        self.callbackWatchRecord(self)
    end
end

--- @return void
function ArenaRecordItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

return ArenaRecordItemView