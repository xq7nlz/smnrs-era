require("lua.client.core.network.arenaTeam.ArenaTeamOpponentDetail")

--- @class UIArenaTeamFormationItemView : IconView
UIArenaTeamFormationItemView = Class(UIArenaTeamFormationItemView, IconView)

--- @return void
function UIArenaTeamFormationItemView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    self.callbackClickChange = nil
end

--- @return void
function UIArenaTeamFormationItemView:SetPrefabName()
    self.prefabName = 'arena_team_formation_item_view'
    self.uiPoolType = UIPoolType.UIArenaTeamFormationItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function UIArenaTeamFormationItemView:SetConfig(transform)
    ---@type ArenaTeamFormationItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonChange.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickChange()
    end)
end

--- @return void
function UIArenaTeamFormationItemView:InitLocalization()

end

--- @return void
---@param battleTeamInfo BattleTeamInfo
function UIArenaTeamFormationItemView:SetData(battleTeamInfo, index)
    self.config.index.text = tostring(index)
    self.config.team.text = string.format("%s %s", LanguageUtils.LocalizeCommon("team"), index)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
        self.battleTeamView = nil
    end
    ---@type BattleTeamView
    self.battleTeamView = BattleTeamView(self.config.formation)
    self.battleTeamView:Show()
    self.battleTeamView:SetDataDefender(UIPoolType.HeroIconView, battleTeamInfo)
    self.battleTeamView.uiTeamView:SetSummonerInfo(battleTeamInfo.summonerBattleInfo)
    self.battleTeamView.uiTeamView:ActiveBuff(false)
    self.battleTeamView.uiTeamView:ActiveLinking(false)

    self.config.ap.text = tostring(math.floor(ClientConfigUtils.GetPowerByBattleTeamInfo(battleTeamInfo)))
end

--- @return void
function UIArenaTeamFormationItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.battleTeamView ~= nil then
        self.battleTeamView:Hide()
        self.battleTeamView = nil
    end
    self.callbackClickChange = nil
end

--- @return void
function UIArenaTeamFormationItemView:OnClickChange()
    if self.callbackClickChange ~= nil then
        self.callbackClickChange()
    end
end

return UIArenaTeamFormationItemView