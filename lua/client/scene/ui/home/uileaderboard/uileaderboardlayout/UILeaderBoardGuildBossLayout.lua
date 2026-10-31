--- @class UILeaderBoardGuildBossLayout : UILeaderBoardLayout
UILeaderBoardGuildBossLayout = Class(UILeaderBoardGuildBossLayout, UILeaderBoardLayout)

--- @type UnityEngine_Vector2
local scrollSize = U_Vector2(1355, 755)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -210, 0)
--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-180, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @param view UILeaderBoardView
function UILeaderBoardGuildBossLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type GuildBossMonthlyStatisticsInBound
    self.rankingData = nil

    --- @type GuildBossConfig
    self.csv = ResourceMgr.GetGuildBossConfig()
    --- @type List
    self.listRankingItemData = nil
end

function UILeaderBoardGuildBossLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("monthly_reward")
    self.localizeCurrentRanking = LanguageUtils.LocalizeCommon("your_current_rank_x")
    self.localizeRewardSend = LanguageUtils.LocalizeCommon("reward_will_sent_x")
end

function UILeaderBoardGuildBossLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        if self.timeRefresh > 0 then
            self.config.textTimer.text = string.format(self.localizeRewardSend, UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTime(self.timeRefresh, 4)))
        else
            self:RemoveUpdateTime()
            self.view:OnReadyHide()
        end
    end
end

function UILeaderBoardGuildBossLayout:OnShow()
    self:InitUpdateTime()
    UILeaderBoardLayout.OnShow(self)
end

function UILeaderBoardGuildBossLayout:CheckDataOnOpen()
    self.rankingData = zg.playerData:GetGuildData().guildBossMonthlyStatisticsData
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardGuildBossLayout:LoadLeaderBoardData()
    GuildBossMonthlyStatisticsInBound.RequestGuildMonthlyStatisticGet(function()
        self:OnLoadedLeaderBoardData()
    end)
end

function UILeaderBoardGuildBossLayout:OnLoadedLeaderBoardData()
    self.rankingData = zg.playerData:GetGuildData().guildBossMonthlyStatisticsData
    self.listRankingItemData = List()

    --- @type GuildBasicInfoInBound
    local guildBasicInfoInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    --- @type List | ItemGuildBossMonthlyStatisticsInBound
    local listStatistics = self.rankingData.listOfStatistics
    for i = 1, listStatistics:Count() do
        --- @type ItemGuildBossMonthlyStatisticsInBound
        local statistics = listStatistics:Get(i)
        local guildMemberInBound = guildBasicInfoInBound:GetMemberInfoById(statistics.playerId)
        if guildMemberInBound ~= nil then
            --- @type {statistics : ItemGuildBossMonthlyStatisticsInBound, guildMemberInBound : GuildMemberInBound, reward : RankingRewardByRangeConfig}
            local member = {}
            member.statistics = statistics
            member.guildMemberInBound = guildMemberInBound
            member.reward = self:GetListRewardByRank(self.listRankingItemData:Count() + 1)
            self.listRankingItemData:Add(member)
        end
    end
    self:StartUpdateTime()
    UILeaderBoardLayout.OnLoadedLeaderBoardData(self)
end

function UILeaderBoardGuildBossLayout:ShowLeaderBoardData()
    self:InitScroll()
    local size = self.listRankingItemData:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardGuildBossLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        local rankingItemData = self.listRankingItemData:Get(dataIndex)
        self:SetItemViewData(obj, dataIndex, rankingItemData)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @return string, string
--- @param scoreData number
function UILeaderBoardGuildBossLayout:_GetRankInfo(scoreData)
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

function UILeaderBoardGuildBossLayout:SetUpLayout()
    UILeaderBoardLayout.SetUpLayout(self)
    self.config.scrollRect.anchoredPosition3D = scrollPosition
    self.config.scrollRect.sizeDelta = scrollSize
end

function UILeaderBoardGuildBossLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:RemoveUpdateTime()
end

--- @param obj LeaderBoardItemView
function UILeaderBoardGuildBossLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @return RankingRewardByRangeConfig
--- @param rank number
function UILeaderBoardGuildBossLayout:GetListRewardByRank(rank)
    local guildLevel = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).guildInfo.guildLevel
    --- @type GuildMonthlyBossRewardConfig
    local guildMonthlyBossRewardConfig = self.csv:GetGuildMonthlyBossRewardConfig()
    --- @type GuildMonthlyRewardTierConfig
    local rewardTierConfig = guildMonthlyBossRewardConfig:GetRewardTierConfigByGuildLevel(guildLevel)
    --- @type List | RankingRewardByRangeConfig
    local listSubRewardByTierConfig = guildMonthlyBossRewardConfig:GetListSubRewardByRewardTier(rewardTierConfig.tier)
    for i = 1, listSubRewardByTierConfig:Count() do
        --- @type RankingRewardByRangeConfig
        local rankingRewardByRangeConfig = listSubRewardByTierConfig:Get(i)
        if rankingRewardByRangeConfig:IsFitRank(rank) then
            return rankingRewardByRangeConfig
        end
    end
    return nil
end

--- @param obj LeaderBoardItemView
--- @param rankValue number
--- @param rankingItemData {statistics : ItemGuildBossMonthlyStatisticsInBound, guildMemberInBound : GuildMemberInBound, reward : RankingRewardByRangeConfig}
function UILeaderBoardGuildBossLayout:SetItemViewData(obj, rankValue, rankingItemData)
    --- @type ItemGuildBossMonthlyStatisticsInBound
    local statistics = rankingItemData.statistics
    --- @type GuildMemberInBound
    local guildMemberInBound = rankingItemData.guildMemberInBound
    --- @type RankingRewardByRangeConfig
    local reward = rankingItemData.reward

    obj:SetName(guildMemberInBound.playerName)
    obj:SetRecordInfo(TimeUtils.GetTimeFromDateTime(statistics.updatedTime))
    obj:SetRankValue(tostring(rankValue))
    obj:SetRankInfo(tostring(statistics.score))
    obj:SetRankTitle(LanguageUtils.LocalizeCommon("total_damage"))

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    --- @type ItemsTableView
    local itemsTableView = obj:InitItemTableView()
    itemsTableView:SetData(reward:GetListRewardItemIcon())

    --- @type VipIconView
    local vipIconView = obj:InitAvatarInfo(UIPoolType.VipIconView)
    vipIconView:SetData2(guildMemberInBound.playerAvatar, guildMemberInBound.playerLevel)

    obj:SetBgText(guildMemberInBound.playerId == PlayerSettingData.playerId)
end

function UILeaderBoardGuildBossLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildBossLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildBossLayout:SetTimeRefresh()
    local serverTime = zg.timeMgr:GetServerTime()
    local date = TimeUtils.GetOsDateFromSecWithFormatT(serverTime)
    local startTimeOfMonth = TimeUtils.GetTimeStartDayFromSec(serverTime) - (date.day - 1) * TimeUtils.SecondADay
    local dayOfMonth = TimeUtils.GetDayOfMonth(date.month, date.year)
    local endTime = startTimeOfMonth + dayOfMonth * TimeUtils.SecondADay
    self.timeRefresh = endTime - zg.timeMgr:GetServerTime()
end