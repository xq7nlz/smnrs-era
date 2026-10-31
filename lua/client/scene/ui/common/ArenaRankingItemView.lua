--- @class ArenaRankingItemView : MotionIconView
ArenaRankingItemView = Class(ArenaRankingItemView, MotionIconView)

--- @return void
function ArenaRankingItemView:Ctor()
    ---@type ArenaOpponentInfo
    MotionIconView.Ctor(self)
    ---@type SingleArenaRanking
    self.singleArenaRanking = nil
    ---@type function
    self.callbackClickInfo = nil
end

--- @return void
function ArenaRankingItemView:SetPrefabName()
    self.prefabName = 'arena_ranking_item_view'
    self.uiPoolType = UIPoolType.ArenaRankingItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function ArenaRankingItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ArenaRankingItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function ArenaRankingItemView:InitLocalization()
    self.config.localizeScore.text = LanguageUtils.LocalizeCommon("point")
end

--- @return void
---@param singleArenaRanking SingleArenaRanking
---@param topNumber number
function ArenaRankingItemView:SetData(singleArenaRanking, topNumber, featureType)
    self.singleArenaRanking = singleArenaRanking
    self.config.iconLeaderBoardTop1.sprite = ClientConfigUtils.GetIconRankingArenaByElo(singleArenaRanking.score, topNumber, featureType)
    self.config.iconLeaderBoardTop1:SetNativeSize()

    if topNumber ~= nil then
        self.config.textLeaderBoardTop.text = tostring(topNumber)
    end
    self.config.power:SetActive(self.singleArenaRanking.power ~= nil)
    if self.singleArenaRanking.power then
        self.config.textAp.text = tostring(self.singleArenaRanking.power)
    end
    self.config.textScorePoint.text = UIUtils.SetColorString(UIUtils.green_dark, self.singleArenaRanking.score)
    self.config.textUserName.text = self.singleArenaRanking.playerName

    --- @type VipIconView
    if self.vipIconView == nil then
        self.vipIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.VipIconView, self.config.heroSlot)
    end
    self.vipIconView:SetData2(self.singleArenaRanking.avatarData:GetOtherPlayerAvatar(), self.singleArenaRanking.playerLevel)
    self.vipIconView:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickInfo()
    end)
end

--- @return void
function ArenaRankingItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

--- @return void
function ArenaRankingItemView:OnClickInfo()
    if self.callbackClickInfo ~= nil then
        self.callbackClickInfo(self)
    end
end

return ArenaRankingItemView