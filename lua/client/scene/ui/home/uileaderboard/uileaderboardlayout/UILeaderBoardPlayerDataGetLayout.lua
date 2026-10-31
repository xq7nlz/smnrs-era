--- @class UILeaderBoardPlayerDataGetLayout : UILeaderBoardLayout
UILeaderBoardPlayerDataGetLayout = Class(UILeaderBoardPlayerDataGetLayout, UILeaderBoardLayout)

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
--- @param leaderBoardType LeaderBoardType
function UILeaderBoardPlayerDataGetLayout:Ctor(view, leaderBoardType)
    UILeaderBoardLayout.Ctor(self, view)
    self.playerDataMethod = self:_GetDataMethod(leaderBoardType)
    --- @type RankingDataInBound
    self.rankingData = nil
    --- @type LeaderBoardItemView
    self.userLeaderBoardItemView = nil
end

function UILeaderBoardPlayerDataGetLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
end

function UILeaderBoardPlayerDataGetLayout:_GetDataMethod(leaderBoardType)
    if leaderBoardType == LeaderBoardType.CAMPAIGN then
        return PlayerDataMethod.CAMPAIGN_RANKING
    elseif leaderBoardType == LeaderBoardType.TOWER then
        return PlayerDataMethod.TOWER_RANKING
    elseif leaderBoardType == LeaderBoardType.DUNGEON then
        return PlayerDataMethod.DUNGEON_RANKING
    elseif leaderBoardType == LeaderBoardType.GUILD_DUNGEON_RANKING then
        return PlayerDataMethod.GUILD_DUNGEON_RANKING
    elseif leaderBoardType == LeaderBoardType.FRIEND_RANKING then
        return PlayerDataMethod.FRIEND_RANKING
    end
end

function UILeaderBoardPlayerDataGetLayout:CheckDataOnOpen()
    self.rankingData = zg.playerData:GetMethod(self.playerDataMethod)
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardPlayerDataGetLayout:LoadLeaderBoardData()
    RankingDataInBound.ReloadDataRanking(self.playerDataMethod, function()
        self:OnLoadedLeaderBoardData()
    end)
end

function UILeaderBoardPlayerDataGetLayout:OnLoadedLeaderBoardData()
    self.rankingData = zg.playerData:GetMethod(self.playerDataMethod)
    UILeaderBoardLayout.OnLoadedLeaderBoardData(self)
end

function UILeaderBoardPlayerDataGetLayout:SetUpSelfRankingInfo()
    local userScore = self.rankingData:GetUserScore()
    if userScore ~= nil and userScore > 0 then
        self:_SetUserRankingItemView()
        self.config.scrollRect.sizeDelta = scrollSizeWithUserItem
    else
        self.config.scrollRect.sizeDelta = scrollSizeWithoutUserItem
    end
    self.config.scrollRect.anchoredPosition3D = scrollPosition
end

function UILeaderBoardPlayerDataGetLayout:ShowLeaderBoardData()
    self:SetUpSelfRankingInfo()
    self:InitScroll()
    local size = self.rankingData.rankingDataList:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardPlayerDataGetLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type RankingItemInBound
        local rankingItemInBound = self.rankingData.rankingDataList:Get(dataIndex)
        self:SetUpItemViewLayout(obj)
        self:SetItemViewData(obj, rankingItemInBound, dataIndex, false)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @return string, string
--- @param scoreData number
function UILeaderBoardPlayerDataGetLayout:_GetRankInfo(scoreData)
    local tittle
    local info
    if self.playerDataMethod == PlayerDataMethod.CAMPAIGN_RANKING then
        local difficultId, mapId, stage = ClientConfigUtils.GetIdFromStageId(scoreData)
        tittle = LanguageUtils.GetHardModeNameById(difficultId)
        info = string.format("%s - %s", mapId, stage)
    elseif self.playerDataMethod == PlayerDataMethod.TOWER_RANKING then
        tittle = LanguageUtils.LocalizeCommon("floor")
        info = tostring(scoreData)
    elseif self.playerDataMethod == PlayerDataMethod.DUNGEON_RANKING then
        local grade = math.floor(scoreData / 100)
        local level = scoreData % 100
        if level > 0 then
            grade = grade + 1
        elseif level == 0 then
            level = 100
        end
        tittle = LanguageUtils.GetHardModeNameById(grade)
        info = tostring(level)
    elseif self.playerDataMethod == PlayerDataMethod.FRIEND_RANKING then
        tittle = LanguageUtils.LocalizeCommon("point")
        info = tostring(scoreData)
    elseif self.playerDataMethod == PlayerDataMethod.GUILD_DUNGEON_RANKING then
        tittle = LanguageUtils.LocalizeCommon("point")
        info = tostring(scoreData)
    end
    return tittle, info
end

function UILeaderBoardPlayerDataGetLayout:DespawnUserRankingItemView()
    if self.userLeaderBoardItemView ~= nil then
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
end

function UILeaderBoardPlayerDataGetLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:DespawnUserRankingItemView()
end

function UILeaderBoardPlayerDataGetLayout:_SetUserRankingItemView()
    self:GetUserRankingItemView()
    local userRankingItemInBound = self.rankingData:GetUserRankingItemInBound()
    self:SetItemViewData(self.userLeaderBoardItemView,
            userRankingItemInBound,
            self.rankingData.userRankingOrder + 1,
            true)
end

function UILeaderBoardPlayerDataGetLayout:GetUserRankingItemView()
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LeaderBoardItemView, self.config.userLeaderBoardItemAnchor)
    end
    self:SetUpItemViewLayout(self.userLeaderBoardItemView)
end

--- @param obj LeaderBoardItemView
function UILeaderBoardPlayerDataGetLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param obj LeaderBoardItemView
--- @param rankingItemInBound RankingItemInBound
--- @param rankValue number
--- @param enableHighlight boolean
function UILeaderBoardPlayerDataGetLayout:SetItemViewData(obj, rankingItemInBound, rankValue, enableHighlight)
    obj:SetName(rankingItemInBound:GetName())
    obj:SetRankValue(tostring(rankValue))

    local recordInfo = ""
    if rankingItemInBound.createdTime ~= nil then
        recordInfo = TimeUtils.GetTimeFromDateTime(rankingItemInBound.createdTime)
    end
    obj:SetRecordInfo(recordInfo)

    local rankTitle, rankInfo = self:_GetRankInfo(rankingItemInBound.score)
    obj:SetRankTitle(rankTitle)
    obj:SetRankInfo(rankInfo)

    --- @type VipIconView
    local vipIconView = obj:InitAvatarInfo(UIPoolType.VipIconView)
    vipIconView:SetData2(rankingItemInBound:GetAvatar(), rankingItemInBound:GetLevel())

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)
    obj:SetBgText(enableHighlight)
end

