require("lua.client.core.network.event.eventLunarNewYear.EventLunarBossRankingInBound")
--- @class UILeaderBoardLunarBossLayout : UILeaderBoardLayout
UILeaderBoardLunarBossLayout = Class(UILeaderBoardLunarBossLayout, UILeaderBoardLayout)

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
function UILeaderBoardLunarBossLayout:Ctor(view)
    UILeaderBoardLayout.Ctor(self, view)
    --- @type EventIgnatiusRankingInBound
    self.rankingData = nil
    --- @type List
    self.listRankingItemData = nil

    --- @type LeaderBoardItemView
    self.userLeaderBoardItemView = nil
end

function UILeaderBoardLunarBossLayout:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
end

function UILeaderBoardLunarBossLayout:CheckDataOnOpen()
    UILeaderBoardLayout.CheckDataOnOpen(self)
end

function UILeaderBoardLunarBossLayout:SetUpSelfRankingInfo()
    --local userScore = self.rankingData:GetUserScore()
    --if userScore ~= nil and userScore > 0 then
    --    --self:_SetUserRankingItemView()
    --    self.config.scrollRect.sizeDelta = scrollSizeWithUserItem
    --else
        self.config.scrollRect.sizeDelta = scrollSizeWithoutUserItem
    --end
    self.config.scrollRect.anchoredPosition3D = scrollPosition
end

function UILeaderBoardLunarBossLayout:OnFinishAnimation()
    self:LoadLeaderBoardData()
end

function UILeaderBoardLunarBossLayout:LoadLeaderBoardData()
    if zg.playerData.dictLunarBossRanking == nil then
        zg.playerData.dictLunarBossRanking = Dictionary()
    end
    ---@type EventLunarBossRankingInBound
    self.eventLunarBossRankingInBound = zg.playerData.dictLunarBossRanking:Get(zg.playerData.currentChapterLunarBoss)
    if self.eventLunarBossRankingInBound == nil or self.eventLunarBossRankingInBound.lastRequest == nil
            or (zg.timeMgr:GetServerTime() - self.eventLunarBossRankingInBound.lastRequest > 60) then
        local onReceived = function(result)
            ---@type EventLunarBossRankingInBound
            local bossRankingInBound = nil
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                bossRankingInBound = EventLunarBossRankingInBound(buffer)
            end
            --- @param logicCode LogicCode
            local onSuccess = function()
                XDebug.Log("UILeaderBoardLunarBossLayout:LoadLeaderBoardData success")
                zg.playerData.dictLunarBossRanking:Add(zg.playerData.currentChapterLunarBoss , bossRankingInBound)
                self.eventLunarBossRankingInBound = bossRankingInBound
                self:OnLoadedLeaderBoardData()
            end
            --- @param logicCode LogicCode
            local onFailed = function(logicCode)
                --SmartPoolUtils.LogicCodeNotification(logicCode)
                self.eventLunarBossRankingInBound = EventLunarBossRankingInBound()
                zg.playerData.dictLunarBossRanking:Add(zg.playerData.currentChapterLunarBoss , self.eventLunarBossRankingInBound)
                self:OnLoadedLeaderBoardData()
            end
            NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
        end
        NetworkUtils.Request(OpCode.EVENT_LUNAR_NEW_YEAR_BOSS_RANKING_GET, UnknownOutBound.CreateInstance(PutMethod.Int, zg.playerData.currentChapterLunarBoss), onReceived, true)
    else
        self:OnLoadedLeaderBoardData()
    end
end

function UILeaderBoardLunarBossLayout:ShowLeaderBoardData()
    self:InitScroll()
    local size = self.eventLunarBossRankingInBound.listRanking:Count()
    self.view:ResizeScroll(size, true)
    self.config.empty:SetActive(size == 0)
end

function UILeaderBoardLunarBossLayout:InitScroll()
    self.view:DespawnScroll()
    --- @param obj LeaderBoardItemView
    --- @param index number
    local onCreateItem = function(obj, index)
        self:SetUpItemViewLayout(obj)

        local dataIndex = index + 1
        local rankingItemData = self.eventLunarBossRankingInBound.listRanking:Get(dataIndex)
        self:SetItemViewData(obj, rankingItemData, dataIndex)
    end
    self.view:InitScroll(UIPoolType.LeaderBoardItemView, onCreateItem)
end

--- @return string, string
--- @param scoreData number
function UILeaderBoardLunarBossLayout:_GetRankInfo(scoreData)
    return LanguageUtils.LocalizeCommon("point"), tostring(scoreData)
end

--function UILeaderBoardLunarBossLayout:SetUpLayout()
--    UILeaderBoardLayout.SetUpLayout(self)
--    self.config.scrollRect.anchoredPosition3D = scrollPosition
--    self.config.scrollRect.sizeDelta = scrollSize
--end

--- @param obj LeaderBoardItemView
function UILeaderBoardLunarBossLayout:SetUpItemViewLayout(obj)
    obj:SetItemSize(itemSize)
    obj:SetRankInfoAnchorPosition(rankInfoAnchorPosition)
end

--- @param obj LeaderBoardItemView
--- @param eventLunarBossRankingData EventLunarBossRankingData
--- @param rankValue number
function UILeaderBoardLunarBossLayout:SetItemViewData(obj, eventLunarBossRankingData, rankValue)
    obj:SetName(eventLunarBossRankingData.guildName)
    obj:SetRankValue(tostring(rankValue))
    obj:SetGuildLevel(eventLunarBossRankingData.guildLevel)
    local recordInfo = ""
    if eventLunarBossRankingData.createdTimeInSec ~= nil then
        recordInfo = TimeUtils.GetTimeFromDateTime(eventLunarBossRankingData.createdTimeInSec)
    end
    obj:SetRecordInfo(recordInfo)

    obj:SetRankTitle(LanguageUtils.LocalizeCommon("score"))
    obj:SetRankInfo(tostring(eventLunarBossRankingData.score))

    local rankIcon
    if rankValue <= LeaderBoardItemView.MaxTopRankHasIcon then
        rankIcon = ResourceLoadUtils.LoadTopRankingIcon(rankValue)
    end
    obj:SetRankIcon(rankIcon)

    --local itemsTableView = obj:InitItemTableView()
    --itemsTableView:SetData(self:GetSeasonRewardByRank(rankValue))

    obj:SetIconGuild(ResourceLoadUtils.LoadGuildIcon(eventLunarBossRankingData.guildAvatar))
    obj:SetBgText(rankValue == self.eventLunarBossRankingInBound.orderRanking + 1)
end

function UILeaderBoardLunarBossLayout:DespawnUserRankingItemView()
    if self.userLeaderBoardItemView ~= nil then
        self.userLeaderBoardItemView:ReturnPool()
        self.userLeaderBoardItemView = nil
    end
end

function UILeaderBoardLunarBossLayout:OnHide()
    UILeaderBoardLayout.OnHide(self)
    self:DespawnUserRankingItemView()
end

function UILeaderBoardLunarBossLayout:_SetUserRankingItemView()
    self:GetUserRankingItemView()
    local userRankingItemInBound = self.rankingData:GetUserRankingItemInBound()
    self:SetItemViewData(self.userLeaderBoardItemView,
            self.rankingData.selfRankingOrder,
            userRankingItemInBound)
end

function UILeaderBoardLunarBossLayout:GetUserRankingItemView()
    if self.userLeaderBoardItemView == nil then
        self.userLeaderBoardItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.LeaderBoardItemView, self.config.userLeaderBoardItemAnchor)
    end
    self:SetUpItemViewLayout(self.userLeaderBoardItemView)
end