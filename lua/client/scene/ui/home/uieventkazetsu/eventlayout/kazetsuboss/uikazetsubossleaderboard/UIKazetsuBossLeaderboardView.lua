--- @class UIKazetsuBossLeaderboardView : UIBaseView
UIKazetsuBossLeaderboardView = Class(UIKazetsuBossLeaderboardView, UIBaseView)

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
	--- @type EventKazetsuModel
	self.eventModel = nil
end

--- @return void
function UIKazetsuBossLeaderboardView:OnReadyCreate()
	---@type UIArenaLeaderboardConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.currentRanking = KazetsuBossLeaderBoardItemView(self.config.arenaRankingItemView)
	self.currentRanking:SetConfig(self.config.arenaRankingItemView)
	self:_InitButtonListener()
	self:InitScroll()
end

function UIKazetsuBossLeaderboardView:InitScroll()
	--require "lua.client.core.network.event.eventKazetsu.KazetsuBossRankingInBound"
	--KazetsuBossRankingInBound.GetLeaderBoard()
	--- @param obj KazetsuBossLeaderBoardItemView
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		---@type KazetsuRanking
		local singleArenaRanking = self.eventModel.KazetsuBossRankingInBound.listRanking:Get(dataIndex)
		local isUser = false

		if (singleArenaRanking.playerId == self.playerId) then
			isUser = true
		end

		obj:SetItemViewData(singleArenaRanking, dataIndex, isUser)
		---@type EventKazetsuConfig
		local eventConfig = self.eventModel:GetConfig()
		local listRewardIcon = eventConfig:GetListRewardByRank(dataIndex)
		obj:SetDataReward(listRewardIcon)
	end

	self.uiScroll = UILoopScroll(self.config.scroll,
			UIPoolType.KazetsuBossLeaderBoardItemView, onCreateItem)
end


function UIKazetsuBossLeaderboardView:_SetUserRankingItemView()
	local userScore = self.eventModel.KazetsuBossRankingInBound.score
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
		rankValue = self.eventModel.KazetsuBossRankingInBound.rankingOrder
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


--- @return void
function UIKazetsuBossLeaderboardView:OnReadyShow()
	self:GetData()
	if self.canPlayMotion == true then
		self.canPlayMotion = false
		self.uiScroll:PlayMotion()
	end
end

function UIKazetsuBossLeaderboardView:GetData()
	local onSuccess = function(eventModel )
		self.playerId = PlayerSettingData.playerId
		self.eventModel = eventModel
		self.uiScroll:Resize(self.eventModel.KazetsuBossRankingInBound.listRanking:Count())
		self:_SetUserRankingItemView()
	end
	require "lua.client.core.network.event.eventKazetsu.KazetsuBossRankingInBound"
	KazetsuBossRankingInBound.GetLeaderBoard(onSuccess)
end

--- @return void
function UIKazetsuBossLeaderboardView:InitLocalization()
	self.config.textLeaderboardTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
	self.config.textTapToClose.gameObject:SetActive(false)
end

function UIKazetsuBossLeaderboardView:_InitButtonListener()
	self.config.bgNone.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIKazetsuBossLeaderboardView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

