require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.uiKazetsuBossLeaderBoard.UIKazetsuBossLeaderboardView"
--- @class UIEventSeasonalBossLeaderboardView : UIKazetsuBossLeaderboardView
UIEventSeasonalBossLeaderboardView = Class(UIEventSeasonalBossLeaderboardView, UIKazetsuBossLeaderboardView)

--- @return void
--- @param model UIArenaLeaderboardModel
function UIKazetsuBossLeaderboardView:Ctor(model)
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type ArenaRankingItemView
    self.currentRanking = nil
    --- @type EventSeasonalModel
    self.eventModel = nil
    UIBaseView.Ctor(self, model)
end

function UIEventSeasonalBossLeaderboardView:GetData()
    local onSuccess = function(eventModel)
        self.playerId = PlayerSettingData.playerId
        self.eventModel = eventModel
        self.uiScroll:Resize(self.eventModel.bossRankingInBound.listRanking:Count())
        self:_SetUserRankingItemView()
    end
    require "lua.client.core.network.event.eventSeasonal.EventSeasonalBossRankingInBound"
    EventSeasonalBossRankingInBound.GetLeaderBoard(onSuccess)
end

function UIEventSeasonalBossLeaderboardView:InitScroll()
    --- @param obj KazetsuBossLeaderBoardItemView
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        ---@type KazetsuRanking
        local singleArenaRanking = self.eventModel.bossRankingInBound.listRanking:Get(dataIndex)
        local isUser = false

        if (singleArenaRanking.playerId == self.playerId) then
            isUser = true
        end

        obj:SetItemViewData(singleArenaRanking, dataIndex, isUser)
        ---@type EventSeasonalConfig
        local eventConfig = self.eventModel:GetConfig()
        local listRewardIcon = eventConfig:GetListRewardByRank(dataIndex)
        obj:SetDataReward(listRewardIcon)
    end

    self.uiScroll = UILoopScroll(self.config.scroll,
            UIPoolType.KazetsuBossLeaderBoardItemView, onCreateItem)
end

function UIEventSeasonalBossLeaderboardView:_SetUserRankingItemView()
    local userScore = self.eventModel.bossRankingInBound.score
    ---@type BasicInfoInBound
    local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
    self.userSingleArenaRanking = SingleArenaRanking()
    self.userSingleArenaRanking.score = userScore
    self.userSingleArenaRanking.avatarData = basicInfo.avatarData
    self.userSingleArenaRanking.playerLevel = basicInfo.playerLevel
    self.userSingleArenaRanking.playerName = basicInfo.name
    local rankValue
    if (userScore == 0) then
        rankValue = -2
    else
        rankValue = self.eventModel.bossRankingInBound.rankingOrder
    end

    self.currentRanking:SetItemViewData(self.userSingleArenaRanking, rankValue + 1, true)
    if (rankValue >= 0) then
        local listRewardIcon = self.eventModel:GetConfig():GetListRewardByRank(rankValue + 1)
        self.currentRanking:SetDataReward(listRewardIcon)
    else
        self.currentRanking:ReturnPoolListReward()
    end
end