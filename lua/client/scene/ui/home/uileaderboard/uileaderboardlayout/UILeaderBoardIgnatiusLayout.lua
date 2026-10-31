--- @class UILeaderBoardIgnatiusLayout : UILeaderBoardLayout
UILeaderBoardIgnatiusLayout = Class(UILeaderBoardIgnatiusLayout, UILeaderBoardLayout)

--- @type UnityEngine_Vector2
local scrollSizeWithUserItem = U_Vector2(1355, 635)
--- @type UnityEngine_Vector2
local scrollSizeWithoutUserItem = U_Vector2(1355, 780)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -170, 0)
--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-37.5, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @param view UILeaderBoardView
function UILeaderBoardIgnatiusLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type EventIgnatiusRankingInBound
    self.rankingData = nil
    --- @type List
    self.listRankingItemData = nil

    --- @type LeaderBoardItemView
    self.userLeaderBoardItemView = nil
end

function UILeaderBoardIgnatiusLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
end

function UILeaderBoardIgnatiusLayout:OnShow()
    ----- @type EventXmasModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    self.rankingData = self.eventModel.eventIgnatiusRankingInBound
    UILeaderBoardLayout.OnShow(self)
end

function UILeaderBoardIgnatiusLayout:CheckDataOnOpen()
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardIgnatiusLayout:SetUpSelfRankingInfo()
    local userScore = self.rankingData:GetUserScore()
    if userScore ~= nil and userScore > 0 then
        self:_SetUserRankingItemView()
        self.config.scrollRect.sizeDelta = scrollSizeWithUserItem
    else
        self.config.scrollRect.sizeDelta = scrollSizeWithoutUserItem
    end
    self.config.scrollRect.anchoredPosition3D = scrollPosition
end

function UILeaderBoardIgnatiusLayout:LoadLeaderBoardData()
    EventIgnatiusRankingInBound.RequestRanking(function()
        self:OnLoadedLeaderBoardData()
    end)
end

function UILeaderBoardIgnatiusLayout:ShowLeaderBoardData()
    ----- @type EventXmasModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    self.rankingData = self.eventModel.eventIgnatiusRankingInBound
    self:SetUpSelfRankingInfo()
    self:InitScroll()
    local size = self.eventModel.eventIgnatiusRankingInBound.listOfStatistics:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardIgnatiusLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        local rankingItemData = self.eventModel.eventIgnatiusRankingInBound.listOfStatistics:Get(dataIndex)
        self:SetItemViewData(obj, dataIndex, rankingItemData)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @return string, string
--- @param scoreData number
function UILeaderBoardIgnatiusLayout:_GetRankInfo(scoreData)
    return LanguageUtils.LocalizeCommon("point"), tostring(scoreData)
end

--function UILeaderBoardIgnatiusLayout:SetUpLayout()
--    UILeaderBoardLayout.SetUpLayout(self)
--    self.config.scrollRect.anchoredPosition3D = scrollPosition
--    self.config.scrollRect.sizeDelta = scrollSize
--end

--- @param obj LeaderBoardItemView
function UILeaderBoardIgnatiusLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param obj LeaderBoardItemView
--- @param rankValue number
--- @param rankingItemData RankingItemInBound
function UILeaderBoardIgnatiusLayout:SetItemViewData(obj, rankValue, rankingItemData)
    obj:SetName(rankingItemData.name)
    obj:SetRecordInfo(TimeUtils.GetTimeFromDateTime(rankingItemData.createdTime))
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
end

function UILeaderBoardIgnatiusLayout:DespawnUserRankingItemView()
    if self.userLeaderBoardItemView ~= nil then
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
end

function UILeaderBoardIgnatiusLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:DespawnUserRankingItemView()
end

function UILeaderBoardIgnatiusLayout:_SetUserRankingItemView()
    self:GetUserRankingItemView()
    local userRankingItemInBound = self.rankingData:GetUserRankingItemInBound()
    self:SetItemViewData(self.userLeaderBoardItemView,
            self.rankingData.selfRankingOrder,
            userRankingItemInBound)
end

function UILeaderBoardIgnatiusLayout:GetUserRankingItemView()
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LeaderBoardItemView, self.config.userLeaderBoardItemAnchor)
    end
    self:SetUpItemViewLayout(self.userLeaderBoardItemView)
end