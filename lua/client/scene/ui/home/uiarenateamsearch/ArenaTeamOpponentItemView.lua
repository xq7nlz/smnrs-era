require("lua.client.core.network.arenaTeam.ArenaTeamOpponentDetail")

--- @class ArenaTeamOpponentItemView : IconView
ArenaTeamOpponentItemView = Class(ArenaTeamOpponentItemView, IconView)

--- @return void
function ArenaTeamOpponentItemView:Ctor()
    ---@type ArenaOpponentInfo
    IconView.Ctor(self)
    ---@type List
    self.listFormation = List()
    ---@type ArenaTeamOpponentBase
    self.arenaOpponentInfo = nil
    self.callbackClickBattle = nil
    ---@type VipIconView
    self.avatarIconView = nil
end

--- @return void
function ArenaTeamOpponentItemView:SetPrefabName()
    self.prefabName = 'arena_team_opponent_item_view'
    self.uiPoolType = UIPoolType.ArenaTeamOpponentItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaTeamOpponentItemView:SetConfig(transform)
    ---@type ArenaTeamOpponentItemConfig
    self.config = UIBaseConfig(transform)

    self.config.buttonBattleArena.onClick:AddListener(function()
        self:OnClickBattle()
    end)
end

--- @return void
function ArenaTeamOpponentItemView:InitLocalization()
    self.config.localizeScore.text = LanguageUtils.LocalizeCommon("point")
    self.config.localizeBattle.text = LanguageUtils.LocalizeCommon("battle")
end

--- @return void
---@param arenaOpponentInfo ArenaTeamOpponentBase
function ArenaTeamOpponentItemView:SetData(arenaOpponentInfo)
    self.arenaOpponentInfo = arenaOpponentInfo
    self.config.iconRankArena.sprite = self.arenaOpponentInfo:GetRankImage()
    self.config.iconRankArena:SetNativeSize()

    --self.power = math.floor(self.arenaOpponentInfo:GetPower())
    self.config.textAp.text = tostring(self.arenaOpponentInfo:GetPower())
    self.config.textScore.text = UIUtils.SetColorString(UIUtils.color2, self.arenaOpponentInfo:GetElo())
    self.config.textPlayerName.text = self.arenaOpponentInfo:GetName()
    if self.avatarIconView == nil then
        self.avatarIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.heroSlot)
    end
    self.avatarIconView:SetData2(self.arenaOpponentInfo:GetAvatar(), self.arenaOpponentInfo:GetLevel())
    self.avatarIconView:AddListener(function()
        self:OnClickInfo()
    end)
end

--- @return void
function ArenaTeamOpponentItemView:OnClickInfo()

    local data = {}
    data.userName = self.arenaOpponentInfo:GetName()
    data.avatar = self.arenaOpponentInfo:GetAvatar()
    data.level = self.arenaOpponentInfo:GetLevel()
    data.power = self.power
    data.listBattleTeamInfo = List()
    if self.arenaOpponentInfo.playerId ~= nil then
        ---@param arenaTeamOpponentDetail ArenaTeamOpponentDetail
        NetworkUtils.SilentRequest(OpCode.ARENA_TEAM_OPPONENT_DETAIL_GET, UnknownOutBound.CreateInstance(PutMethod.Long, self.arenaOpponentInfo.playerId),
                ArenaTeamOpponentDetail, function (arenaTeamOpponentDetail)
                    for i = 1, 3 do
                        ---@type BattleTeamInfo
                        local battleTeamInfo = arenaTeamOpponentDetail:GetBattleTeamInfoArenaTeam(i)
                        data.listBattleTeamInfo:Add(battleTeamInfo)
                    end
                    PopupMgr.ShowPopup(UIPopupName.UIArenaTeamOpponentInfo, data)
                end , nil, nil, 100)
    else
        for i = 1, 3 do
            ---@type BattleTeamInfo
            local battleTeamInfo = self.arenaOpponentInfo:GetBattleTeamInfoArenaTeam(i)
            data.listBattleTeamInfo:Add(battleTeamInfo)
        end
        PopupMgr.ShowPopup(UIPopupName.UIArenaTeamOpponentInfo, data)
    end
end


--- @return void
function ArenaTeamOpponentItemView:ReturnPool()
    IconView.ReturnPool(self)
    if self.avatarIconView ~= nil then
        self.avatarIconView:ReturnPool()
        self.avatarIconView = nil
    end
end

--- @return void
function ArenaTeamOpponentItemView:OnClickBattle()
    if self.callbackClickBattle ~= nil then
        self.callbackClickBattle()
    end
end

return ArenaTeamOpponentItemView