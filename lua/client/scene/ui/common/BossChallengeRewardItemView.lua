--- @class BossChallengeRewardItemView : IconView
BossChallengeRewardItemView = Class(BossChallengeRewardItemView, IconView)

--- @return void
function BossChallengeRewardItemView:Ctor()
    --- @type UnityEngine_Color
    self.color = nil
    IconView.Ctor(self)
    ---@type BossChallengeRewardRankingConfig
    self.rewardRanking = nil
    ---@type List
    self.listReward = List()
end

--- @return void
function BossChallengeRewardItemView:SetPrefabName()
    self.prefabName = 'boss_challenge_reward_item_view'
    self.uiPoolType = UIPoolType.BossChallengeRewardItemView
end

--- @return void
--- @param transform UnityEngine_Transform
function BossChallengeRewardItemView:SetConfig(transform)
    --- @type BossChallengeRewardItemConfig
    self.config = UIBaseConfig(transform)
    self.color = self.config.textRankName.color
end

--- @return void
---@param rewardRanking BossChallengeRewardRankingConfig
---@param isCurrentRanking boolean
function BossChallengeRewardItemView:SetData(rewardRanking, isCurrentRanking, featureType)
    self.config.currentRank:SetActive(isCurrentRanking or false)
    self.rewardRanking = rewardRanking

    self.config.iconLeaderBoard.sprite = ResourceLoadUtils.LoadArenaRankIcon(rewardRanking.rankType)

    if rewardRanking.rankType == 7 then
        self.config.textRankName.text = LanguageUtils.LocalizeCommon("ranking_top_11")
    else
        self.config.textRankName.text = LanguageUtils.LocalizeRanking(rewardRanking.rankType)
    end

    self.config.iconLeaderBoard:SetNativeSize()
    local topRankingPoint = ""
    if rewardRanking.bossMin >= 0 and rewardRanking.bossMax >= 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x_x"),
                rewardRanking.bossMin * 100, rewardRanking.bossMax * 100)
    elseif rewardRanking.bossMin < 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x-"),
                rewardRanking.bossMax * 100)
    elseif rewardRanking.bossMax < 0 then
        topRankingPoint = StringUtils.FormatLocalizeStart1(LanguageUtils.LocalizeCommon("point_x+"),
                rewardRanking.bossMin * 100)
    end

    self.config.textLeaderBoardTop.text = topRankingPoint

    --- @param v ItemIconData
    for _, v in pairs(rewardRanking.listRewardItem:GetItems()) do
        ---@type RootIconView
        local rootIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
        rootIconView:SetIconData(v)
        rootIconView:RegisterShowInfo()
        self.listReward:Add(rootIconView)
    end

    if isCurrentRanking == true then
        self.config.textRankName.color = U_Color.white
    else
        self.config.textRankName.color = self.color
    end
end

--- @return void
function BossChallengeRewardItemView:ReturnPoolListReward()
    ---@type IconView
    for _, v in pairs(self.listReward:GetItems()) do
        v:ReturnPool()
    end
    self.listReward:Clear()
end

--- @return void
function BossChallengeRewardItemView:ReturnPool()
    IconView.ReturnPool(self)
    self:ReturnPoolListReward()
end

return BossChallengeRewardItemView