--- @class UILeaderBoardGuildWarRankingLayout : UILeaderBoardLayout
UILeaderBoardGuildWarRankingLayout = Class(UILeaderBoardGuildWarRankingLayout, UILeaderBoardLayout)

--- @type UnityEngine_Vector2
local scrollSize = U_Vector2(1355, 755)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -210, 0)
--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-66, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @param view UILeaderBoardView
function UILeaderBoardGuildWarRankingLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type GuildWarRankingInBound
    self.rankingData = nil
    --- @type GuildWarListRankingRewardConfig
    self.csv = ResourceMgr.GetGuildDataConfig():GetGuildWarDataConfig():GetGuildWarSeasonRewardConfig()
end

function UILeaderBoardGuildWarRankingLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("guild_war_season_ranking")
    self.localizeRewardSend = LanguageUtils.LocalizeCommon("reward_will_sent_x")
end

function UILeaderBoardGuildWarRankingLayout:InitUpdateTime()
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

function UILeaderBoardGuildWarRankingLayout:OnShow()
    --- @type GuildBasicInfoInBound
    self.guildBasicInfo = zg.playerData:GetMethod(PlayerDataMethod.GUILD_BASIC_INFO)
    self:InitUpdateTime()
    UILeaderBoardLayout.OnShow(self)
end

function UILeaderBoardGuildWarRankingLayout:CheckDataOnOpen()
    self.rankingData = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_RANKING)
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardGuildWarRankingLayout:LoadLeaderBoardData()
    GuildWarRankingInBound.Validate(function()
        self:OnLoadedLeaderBoardData()
    end)
end

function UILeaderBoardGuildWarRankingLayout:OnLoadedLeaderBoardData()
    self.rankingData = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_RANKING)
    self:StartUpdateTime()
    UILeaderBoardLayout.OnLoadedLeaderBoardData(self)
end

function UILeaderBoardGuildWarRankingLayout:ShowLeaderBoardData()
    self:InitScroll()
    local size = self.rankingData.listGuildWarRanking:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardGuildWarRankingLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        local rankingItemData = self.rankingData.listGuildWarRanking:Get(dataIndex)
        self:SetItemViewData(obj, dataIndex, rankingItemData)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

function UILeaderBoardGuildWarRankingLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildWarRankingLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UILeaderBoardGuildWarRankingLayout:SetTimeRefresh()
    --- @type GuildWarTimeInBound
    local guildWarTimeInBound = zg.playerData:GetMethod(PlayerDataMethod.GUILD_WAR_TIME)
    self.timeRefresh = guildWarTimeInBound.seasonTime.endTime - zg.timeMgr:GetServerTime()
end

function UILeaderBoardGuildWarRankingLayout:SetUpLayout()
    UILeaderBoardLayout.SetUpLayout(self)
    self.config.scrollRect.anchoredPosition3D = scrollPosition
    self.config.scrollRect.sizeDelta = scrollSize
end

function UILeaderBoardGuildWarRankingLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:RemoveUpdateTime()
end

--- @param obj LeaderBoardItemView
--- @param rankValue number
--- @param guildWarRanking GuildWarRanking
function UILeaderBoardGuildWarRankingLayout:SetItemViewData(obj, rankValue, guildWarRanking)
    ----- @type RankingRewardByRangeConfig
    --local rankingRewardByRangeConfig = self.csv:GetRankingRewardByRangeConfig(rankValue)
    obj:SetName(guildWarRanking.guildName)
    obj:SetRankValue(tostring(rankValue))
    obj:SetRankInfo(tostring(guildWarRanking.guildScore))
    obj:SetRecordInfo(TimeUtils.GetTimeFromDateTime(guildWarRanking.createdTime))
    obj:SetRankTitle(LanguageUtils.LocalizeCommon("score"))

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    ----- @type ItemsTableView
    --local itemsTableView = obj:InitItemTableView()
    --itemsTableView:SetData(rankingRewardByRangeConfig:GetListRewardItemIcon())

    obj:SetIconGuild(ResourceLoadUtils.LoadGuildIcon(guildWarRanking.guildAvatar))
    obj:SetBgText(guildWarRanking.guildId == self.guildBasicInfo.guildInfo.guildId)
end

--- @param obj LeaderBoardItemView
function UILeaderBoardGuildWarRankingLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end
