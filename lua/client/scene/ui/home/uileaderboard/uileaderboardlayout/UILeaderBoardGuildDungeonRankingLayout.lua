--- @class UILeaderBoardGuildDungeonRankingLayout : UILeaderBoardPlayerDataGetLayout
UILeaderBoardGuildDungeonRankingLayout = Class(UILeaderBoardGuildDungeonRankingLayout, UILeaderBoardPlayerDataGetLayout)

--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-180, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @type UnityEngine_Vector2
local scrollSize = U_Vector2(1355, 755)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -210, 0)

--- @param view UILeaderBoardView
--- @param leaderBoardType LeaderBoardType
function UILeaderBoardGuildDungeonRankingLayout:Ctor(view, leaderBoardType)
    UILeaderBoardPlayerDataGetLayout.Ctor(self, view, leaderBoardType)
    --- @type GuildDungeonRankingDataInBound
    self.rankingData = nil
    --- @type GuildDungeonConfig
    self.csv = ResourceMgr.GetGuildDungeonConfig()
    --- @type GuildInfoInBound
    self.guildInfo = nil
end

function UILeaderBoardGuildDungeonRankingLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("season_ranking")
    self.localizeRewardSend = LanguageUtils.LocalizeCommon("reward_will_sent_x")
end

function UILeaderBoardGuildDungeonRankingLayout:OnShow()
    self:InitUpdateTime()
    UILeaderBoardPlayerDataGetLayout.OnShow(self)
end

function UILeaderBoardGuildDungeonRankingLayout:InitUpdateTime()
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

function UILeaderBoardGuildDungeonRankingLayout:SetUpLayout()
    UILeaderBoardPlayerDataGetLayout.SetUpLayout(self)
    self.config.scrollRect.sizeDelta = scrollSize
    self.config.scrollRect.anchoredPosition3D = scrollPosition

    self.config.buttonNext.gameObject:SetActive(true)
    self.config.page.gameObject:SetActive(true)
    self:SetUpButtonPage()
end

function UILeaderBoardGuildDungeonRankingLayout:OnLoadedLeaderBoardData()
    self.guildInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO).guildInfo
    UILeaderBoardPlayerDataGetLayout.OnLoadedLeaderBoardData(self)
    self:StartUpdateTime()
end

function UILeaderBoardGuildDungeonRankingLayout:ShowLeaderBoardData()
    self:InitScroll()
    local size = self.rankingData.listOfGuildRankingOrder:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardGuildDungeonRankingLayout:OnClickNextPage()
    self.view:OnReadyShow(LeaderBoardType.GUILD_DUNGEON_SEASON_RANKING)
end

function UILeaderBoardGuildDungeonRankingLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type GuildDungeonRankingInBound
        if dataIndex > self.rankingData.listOfGuildRankingOrder:Count() then
            XDebug.Error(string.format("UILeaderBoardGuildDungeonRankingLayout:InitScroll %s %s", tostring(dataIndex), tostring(self.rankingData.listOfGuildRankingOrder:Count())))
            return
        end
        local guildDungeonRankingInBound = self.rankingData.listOfGuildRankingOrder:Get(dataIndex)
        self:SetUpItemViewLayout(obj)
        self:SetItemViewData(obj, guildDungeonRankingInBound, dataIndex)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @param obj LeaderBoardItemView
--- @param guildDungeonRankingInBound GuildDungeonRankingInBound
--- @param rankValue number
function UILeaderBoardGuildDungeonRankingLayout:SetItemViewData(obj, guildDungeonRankingInBound, rankValue)
    obj:SetName(guildDungeonRankingInBound.guildName)
    obj:SetRankValue(tostring(rankValue))
    obj:SetGuildLevel(guildDungeonRankingInBound.guildLevel)
    local recordInfo = ""
    if guildDungeonRankingInBound.createdTimeInSec ~= nil then
        recordInfo = TimeUtils.GetTimeFromDateTime(guildDungeonRankingInBound.createdTimeInSec)
    end
    obj:SetRecordInfo(recordInfo)

    obj:SetRankTitle(LanguageUtils.LocalizeCommon("score"))
    obj:SetRankInfo(tostring(guildDungeonRankingInBound.score))

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    local itemsTableView = obj:InitItemTableView()
    itemsTableView:SetData(self:GetSeasonRewardByRank(rankValue))

    obj:SetIconGuild(ResourceLoadUtils.LoadGuildIcon(guildDungeonRankingInBound.guildAvatar))
    obj:SetBgText(self.guildInfo.guildId == guildDungeonRankingInBound.guildId)
end

--- @param obj LeaderBoardItemView
function UILeaderBoardGuildDungeonRankingLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param rank number
function UILeaderBoardGuildDungeonRankingLayout:GetSeasonRewardByRank(rank)
    local listSubRewardByTierConfig = self.csv:GetSeasonRewardConfig()
    for i = 1, listSubRewardByTierConfig:Count() do
        --- @type RankingRewardByRangeConfig
        local subConfig = listSubRewardByTierConfig:Get(i)
        if subConfig:IsFitRank(rank) then
            return subConfig:GetListRewardItemIcon()
        end
    end
    return List()
end

function UILeaderBoardGuildDungeonRankingLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildDungeonRankingLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildDungeonRankingLayout:SetTimeRefresh()
    local endTime = zg.playerData:GetEvents():GetEvent(EventTimeType.GUILD_DUNGEON):GetTime().endTime
    self.timeRefresh = endTime - zg.timeMgr:GetServerTime()
end

function UILeaderBoardGuildDungeonRankingLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:RemoveUpdateTime()
end

function UILeaderBoardGuildDungeonRankingLayout:SetUpButtonPage()
    if self.uiSelectPage == nil then
        --- @param obj UIBlackMarketPageConfig
        --- @param isSelect boolean
        local onSelect = function(obj, isSelect)
            obj.imageOn:SetActive(isSelect)
        end
        --- @param indexTab number
        local onChangeSelect = function(indexTab)
        end
        self.uiSelectPage = UISelect(self.config.page, UIBaseConfig, onSelect, onChangeSelect)
    end
    self.uiSelectPage:SetPagesCount(2)
    self.uiSelectPage:Select(1)
end
