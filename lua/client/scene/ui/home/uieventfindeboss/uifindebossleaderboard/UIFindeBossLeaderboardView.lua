require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.KazetsuBoss.uiKazetsuBossLeaderBoard.UIKazetsuBossLeaderboardView"
--- @class UIFindeBossLeaderboardView : UIKazetsuBossLeaderboardView
UIFindeBossLeaderboardView = Class(UIFindeBossLeaderboardView, UIKazetsuBossLeaderboardView)


--- @return void
--- @param model UIArenaLeaderboardModel
function UIKazetsuBossLeaderboardView:Ctor(model)
	--- @type UILoopScroll
	self.uiScroll = nil
	---@type ArenaRankingItemView
	self.currentRanking = nil
	UIBaseView.Ctor(self, model)
	--- @type UIArenaLeaderboardModel
	self.model = model
	--- @type EventFindeBossModel
	self.eventModel = nil
end


function UIFindeBossLeaderboardView:GetData()
	local onSuccess = function(eventModel)
		self.playerId = PlayerSettingData.playerId
		self.eventModel = eventModel
		self.uiScroll:Resize(self.eventModel.findeBossRankingInBound.listRanking:Count())
		self:_SetUserRankingItemView()
	end
	require "lua.client.core.network.event.eventFindeBoss.FindeBossRankingInBound"
	FindeBossRankingInBound.GetLeaderBoard(onSuccess)
end

function UIFindeBossLeaderboardView:InitScroll()
	--require "lua.client.core.network.event.eventKazetsu.KazetsuBossRankingInBound"
	--KazetsuBossRankingInBound.GetLeaderBoard()
	--- @param obj KazetsuBossLeaderBoardItemView
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		---@type KazetsuRanking
		local singleArenaRanking = self.eventModel.findeBossRankingInBound.listRanking:Get(dataIndex)
		local isUser = false

		if (singleArenaRanking.playerId == self.playerId) then
			isUser = true
		end

		obj:SetItemViewData(singleArenaRanking, dataIndex, isUser)
		---@type EventFindeBossChallengeConfig
		local eventConfig = self.eventModel:GetConfig()
		local listRewardIcon = eventConfig:GetListRewardByRank(dataIndex)
		obj:SetDataReward(listRewardIcon)
	end

	self.uiScroll = UILoopScroll(self.config.scroll,
			UIPoolType.KazetsuBossLeaderBoardItemView, onCreateItem)
end

function UIFindeBossLeaderboardView:_SetUserRankingItemView()
	local userScore = self.eventModel.findeBossRankingInBound.score
	--[[    self.config.packTimer.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
				UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh, 4)))]]
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
		rankValue = self.eventModel.findeBossRankingInBound.rankingOrder
	end

	self.currentRanking:SetItemViewData(
			self.userSingleArenaRanking,
			rankValue + 1,
			true)
	if (rankValue >= 0) then
		local listRewardIcon = self.eventModel:GetConfig():GetListRewardByRank(rankValue + 1)
		self.currentRanking:SetDataReward(listRewardIcon)
	end
end