--- @class UILeaderBoardGuildDungeonSeasonLayout : UILeaderBoardLayout
UILeaderBoardGuildDungeonSeasonLayout = Class(UILeaderBoardGuildDungeonSeasonLayout, UILeaderBoardLayout)

--- @type UnityEngine_Vector3
local rankInfoAnchorPosition = U_Vector3(-37.5, 0, 0)
--- @type UnityEngine_Vector3
local itemSize = U_Vector2(1300, 148)

--- @type UnityEngine_Vector2
local scrollSize = U_Vector2(1355, 780)
--- @type UnityEngine_Vector3
local scrollPosition = U_Vector3(0, -170, 0)

--- @param view UILeaderBoardView
function UILeaderBoardGuildDungeonSeasonLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type GuildDungeonStatisticsGetInBound
    self.rankingData = nil
end

function UILeaderBoardGuildDungeonSeasonLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("season_ranking")
end

function UILeaderBoardGuildDungeonSeasonLayout:SetUpLayout()
    UILeaderBoardLayout.SetUpLayout(self)
    self.config.scrollRect.anchoredPosition3D = scrollPosition
    self.config.scrollRect.sizeDelta = scrollSize

    self.config.buttonPrev.gameObject:SetActive(true)
    self.config.page.gameObject:SetActive(true)
    self:SetUpButtonPage()
end

function UILeaderBoardGuildDungeonSeasonLayout:CheckDataOnOpen()
    self.rankingData = zg.playerData:GetGuildData().guildDungeonStatisticsGetInBound
    if self:IsNeedRequestData() then
        self.config.loading:SetActive(true)
        self:LoadLeaderBoardData()
    else
        self:OnLoadedLeaderBoardData()
    end
end

function UILeaderBoardGuildDungeonSeasonLayout:LoadLeaderBoardData()
    GuildDungeonStatisticsGetInBound.RequestGuildDungeonStatisticGet(function ()
        self:OnLoadedLeaderBoardData()
    end, LanguageUtils.LogicCodeNotification)
end

function UILeaderBoardGuildDungeonSeasonLayout:OnLoadedLeaderBoardData()
    self.rankingData = zg.playerData:GetGuildData().guildDungeonStatisticsGetInBound
    UILeaderBoardLayout.OnLoadedLeaderBoardData(self)
end

function UILeaderBoardGuildDungeonSeasonLayout:ShowLeaderBoardData()
    self:InitScroll()
    local size = self.rankingData.listGuildDungeonStatistics:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardGuildDungeonSeasonLayout:InitScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        --- @type GuildDungeonStatisticsInBound
        local guildDungeonStatisticsInBound = self.rankingData.listGuildDungeonStatistics:Get(dataIndex)
        self:SetItemViewData(obj, dataIndex, guildDungeonStatisticsInBound)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @param obj LeaderBoardItemView
function UILeaderBoardGuildDungeonSeasonLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

function UILeaderBoardGuildDungeonSeasonLayout:OnClickPrevPage()
    self.view:OnReadyShow(LeaderBoardType.GUILD_DUNGEON_RANKING)
end

--- @param obj LeaderBoardItemView
--- @param rankValue number
--- @param guildDungeonStatisticsInBound GuildDungeonStatisticsInBound
function UILeaderBoardGuildDungeonSeasonLayout:SetItemViewData(obj, rankValue, guildDungeonStatisticsInBound)
    obj:SetRankValue(tostring(rankValue))
    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    obj:SetName(guildDungeonStatisticsInBound.playerName)
    obj:SetRecordInfo(string.format("%s: %s", LanguageUtils.LocalizeCommon("attack_count"), guildDungeonStatisticsInBound.numberAttack))
    obj:SetRankInfo(tostring(guildDungeonStatisticsInBound.playerScore))
    obj:SetRankTitle(LanguageUtils.LocalizeCommon("score"))

    --- @type VipIconView
    local vipIconView = obj:InitAvatarInfo(UIPoolType.VipIconView)
    vipIconView:SetData2(guildDungeonStatisticsInBound.playerAvatar, guildDungeonStatisticsInBound.playerLevel)

    obj:SetBgText(guildDungeonStatisticsInBound.playerId == PlayerSettingData.playerId)
end

function UILeaderBoardGuildDungeonSeasonLayout:SetUpButtonPage()
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
    self.uiSelectPage:Select(2)
end

