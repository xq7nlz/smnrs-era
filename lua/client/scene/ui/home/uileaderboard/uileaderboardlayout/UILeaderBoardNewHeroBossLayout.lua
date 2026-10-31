--- @class UILeaderBoardNewHeroBossLayout : UILeaderBoardLayout
UILeaderBoardNewHeroBossLayout = Class(UILeaderBoardNewHeroBossLayout, UILeaderBoardLayout)

--- @type UnityEngine_Vector2
local scrollSizeWithUserItem = U_Vector2(1355, 635)
--- @type UnityEngine_Vector2
local scrollSizeWithoutUserItem = U_Vector2(1355, 780)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -170, 0)
--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-475, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @param view UILeaderBoardView
function UILeaderBoardNewHeroBossLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type EventNewHeroBossRankingInBound
    self.rankingData = nil
    --- @type List
    self.listRankingItemData = nil

    --- @type LeaderBoardItemView
    self.userLeaderBoardItemView = nil
    ---@type EventNewHeroBossChallengeConfig
    self.eventConfig = nil
end

function UILeaderBoardNewHeroBossLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
end

function UILeaderBoardNewHeroBossLayout:OnShow()
    ----- @type EventNewHeroBossChallengeModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE)
    self.eventConfig = self.eventModel:GetConfig()
    self.rankingData = self.eventModel.eventRankingInBound
    UILeaderBoardLayout.OnShow(self)
end

function UILeaderBoardNewHeroBossLayout:CheckDataOnOpen()
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardNewHeroBossLayout:SetUpSelfRankingInfo()
    local userScore = self.rankingData:GetUserScore()
    if userScore ~= nil and userScore > 0 then
        self:_SetUserRankingItemView()
        self.config.scrollRect.sizeDelta = scrollSizeWithUserItem
    else
        self.config.scrollRect.sizeDelta = scrollSizeWithoutUserItem
    end
    self.config.scrollRect.anchoredPosition3D = scrollPosition
end

function UILeaderBoardNewHeroBossLayout:LoadLeaderBoardData()
    EventNewHeroBossRankingInBound.RequestRanking(function()
        self:OnLoadedLeaderBoardData()
    end)
end

function UILeaderBoardNewHeroBossLayout:ShowLeaderBoardData()
    ----- @type EventNewHeroBossChallengeModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_HERO_BOSS_CHALLENGE)
    self.rankingData = self.eventModel.eventRankingInBound
    self:SetUpSelfRankingInfo()
    self:InitScroll()
    local size = self.eventModel.eventRankingInBound.listOfStatistics:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardNewHeroBossLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        ---@type RankingDataInBound
        local rankingItemData = self.eventModel.eventRankingInBound.listOfStatistics:Get(dataIndex)
        self:SetItemViewData(obj, dataIndex, rankingItemData)

    end
    self.view:InitScroll(UIPoolType.LeaderBoardNewHeroItemView, onCreateItem)
end

--- @return string, string
--- @param scoreData number
function UILeaderBoardNewHeroBossLayout:_GetRankInfo(scoreData)
    return LanguageUtils.LocalizeCommon("point"), tostring(scoreData)
end

--function UILeaderBoardNewHeroBossLayout:SetUpLayout()
--    UILeaderBoardLayout.SetUpLayout(self)
--    self.config.scrollRect.anchoredPosition3D = scrollPosition
--    self.config.scrollRect.sizeDelta = scrollSize
--end

--- @param obj LeaderBoardItemView
function UILeaderBoardNewHeroBossLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param obj LeaderBoardItemView
--- @param rankValue number
--- @param rankingItemData RankingItemInBound2
function UILeaderBoardNewHeroBossLayout:SetItemViewData(obj, rankValue, rankingItemData)
    obj:SetName(rankingItemData.name)
    --obj:SetRecordInfo(TimeUtils.GetTimeFromDateTime(rankingItemData.createdTime))
    obj:SetPower(rankingItemData.power)
    obj:SetRankValue(tostring(rankValue))
    obj:SetRankInfo(tostring(rankingItemData.score))
    obj:SetRankTitle(LanguageUtils.LocalizeCommon("highest_damage"))

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    --- @type VipIconView
    local vipIconView = obj:InitAvatarInfo(UIPoolType.VipIconView)
    vipIconView:SetData2(rankingItemData.avatar, rankingItemData.level)

    obj:SetBgText(rankingItemData.id == PlayerSettingData.playerId)

    --- @type ItemsTableView
    local itemsTableView = obj:InitItemTableView()
    local listReward = self.eventConfig:GetListRewardRanking(rankValue)
    if listReward ~= nil then
        itemsTableView:SetData(RewardInBound.GetItemIconDataList(self.eventConfig:GetListRewardRanking(rankValue)))
    end
end

function UILeaderBoardNewHeroBossLayout:DespawnUserRankingItemView()
    if self.userLeaderBoardItemView ~= nil then
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
end

function UILeaderBoardNewHeroBossLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:DespawnUserRankingItemView()
end

function UILeaderBoardNewHeroBossLayout:_SetUserRankingItemView()
    self:GetUserRankingItemView()
    local userRankingItemInBound = self.rankingData:GetUserRankingItemInBound()
    self:SetItemViewData(self.userLeaderBoardItemView,
            self.rankingData.selfRankingOrder,
            userRankingItemInBound)
end

function UILeaderBoardNewHeroBossLayout:GetUserRankingItemView()
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LeaderBoardNewHeroItemView, self.config.userLeaderBoardItemAnchor)
    end
    self:SetUpItemViewLayout(self.userLeaderBoardItemView)
end