--- @class BossChallengeRankingItemView : MotionIconView
BossChallengeRankingItemView = Class(BossChallengeRankingItemView, MotionIconView)

--- @return void
function BossChallengeRankingItemView:Ctor()
    ---@type ArenaOpponentInfo
    MotionIconView.Ctor(self)
    ---@type SingleArenaRanking
    self.singleArenaRanking = nil
    ---@type function
    self.callbackClickInfo = nil
end

--- @return void
function BossChallengeRankingItemView:SetPrefabName()
    self.prefabName = 'boss_challenge_ranking_item_view'
    self.uiPoolType = UIPoolType.BossChallengeRankingItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function BossChallengeRankingItemView:SetConfig(transform)
    MotionIconView.SetConfig(self, transform)
    ---@type ArenaRankingItemConfig
    self.config = UIBaseConfig(transform)
end

--- @return void
function BossChallengeRankingItemView:InitLocalization()
    self.config.localizeScore.text = LanguageUtils.LocalizeCommon("point")
end

--- @return void
---@param singleArenaRanking SingleArenaRanking
---@param topNumber number
function BossChallengeRankingItemView:SetData(singleArenaRanking, topNumber)
    self.singleArenaRanking = singleArenaRanking
    --- @type EventBossChallengeModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
    ----- @type EventBossChallengeConfig
    self.eventConfig = self.eventModel:GetConfig()
    local rankType = self.eventConfig:GetRankingTypeByScore(singleArenaRanking.score)
    self.config.iconLeaderBoardTop1.sprite = ResourceLoadUtils.LoadArenaRankIcon(rankType)
    self.config.iconLeaderBoardTop1:SetNativeSize()

    if topNumber ~= nil then
        self.config.textLeaderBoardTop.text = tostring(topNumber)
    else
        self.config.textLeaderBoardTop.text = ""
    end
    self.config.power:SetActive(self.singleArenaRanking.power ~= nil)
    if self.singleArenaRanking.power then
        self.config.textAp.text = tostring(self.singleArenaRanking.power)
    end
    self.config.textScorePoint.text = UIUtils.SetColorString(UIUtils.green_dark, self.singleArenaRanking.score * 100)
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
function BossChallengeRankingItemView:ReturnPool()
    MotionIconView.ReturnPool(self)
    if self.vipIconView ~= nil then
        self.vipIconView:ReturnPool()
        self.vipIconView = nil
    end
end

--- @return void
function BossChallengeRankingItemView:OnClickInfo()
    if self.callbackClickInfo ~= nil then
        self.callbackClickInfo(self)
    end
end

return BossChallengeRankingItemView