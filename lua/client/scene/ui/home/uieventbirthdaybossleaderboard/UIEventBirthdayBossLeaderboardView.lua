--- @class UIEventBirthdayBossLeaderboardView : UIBaseView
UIEventBirthdayBossLeaderboardView = Class(UIEventBirthdayBossLeaderboardView, UIBaseView)

--- @return void
--- @param model UIArenaLeaderboardModel
function UIEventBirthdayBossLeaderboardView:Ctor(model)
	--- @type UILoopScroll
	self.uiScroll = nil
	---@type ArenaRankingItemView
	self.currentRanking = nil
	UIBaseView.Ctor(self, model)
	--- @type UIArenaLeaderboardModel
	self.model = model
	--- @type EventBirthdayModel
	self.eventModel = nil
end

--- @return void
function UIEventBirthdayBossLeaderboardView:OnReadyCreate()
	---@type UIArenaLeaderboardConfig
	self.config = UIBaseConfig(self.uiTransform)
	self.currentRanking = BirthdayBossLeaderBoardItemView(self.config.arenaRankingItemView)
	self.currentRanking:SetConfig(self.config.arenaRankingItemView)
	self:_InitButtonListener()
	self:InitScroll()
end

function UIEventBirthdayBossLeaderboardView:InitScroll()
	--- @param obj BirthdayBossLeaderBoardItemView
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		---@type BirthdayRanking
		local singleArenaRanking = self.eventModel.birthdayBossRankingInBound.listRanking:Get(dataIndex)
		local isUser = false

		if (singleArenaRanking.playerId == self.playerId) then
			isUser = true
		end

		obj:SetItemViewData(singleArenaRanking, dataIndex, isUser)
		---@type EventBirthdayConfig
		local eventConfig = self.eventModel:GetConfig()
		local listRewardIcon = eventConfig.bossConfig:GetListRewardByRank(dataIndex)
		obj:SetDataReward(listRewardIcon)
	end

	self.uiScroll = UILoopScroll(self.config.scroll,
			UIPoolType.BirthdayBossLeaderBoardItemView, onCreateItem)
end


function UIEventBirthdayBossLeaderboardView:_SetUserRankingItemView()
	local userScore = self.eventModel.birthdayBossRankingInBound.score
	local factionType = self.eventModel.selectSideId
	---@type BasicInfoInBound
	local basicInfo = zg.playerData:GetMethod(PlayerDataMethod.BASIC_INFO)
	self.userSingleArenaRanking = SingleArenaRanking()
	self.userSingleArenaRanking.score = userScore
	self.userSingleArenaRanking.avatarData = basicInfo.avatarData
	self.userSingleArenaRanking.playerLevel = basicInfo.playerLevel
	self.userSingleArenaRanking.playerName = basicInfo.name
	self.userSingleArenaRanking.factionId = factionType
	local rankValue
	if (userScore == 0) then
		rankValue = -2
	else
		rankValue = self.eventModel.birthdayBossRankingInBound.rankingOrder
	end

	self.currentRanking:SetItemViewData(
			self.userSingleArenaRanking,
			rankValue + 1,
			true)
	if (rankValue >= 0) then
		local listRewardIcon = self.eventModel:GetConfig().bossConfig:GetListRewardByRank(rankValue + 1)
		 self.currentRanking:SetDataReward(listRewardIcon)
	end
end


--- @return void
function UIEventBirthdayBossLeaderboardView:OnReadyShow()
	self:GetData()
	if self.canPlayMotion == true then
		self.canPlayMotion = false
		self.uiScroll:PlayMotion()
	end
end

function UIEventBirthdayBossLeaderboardView:GetData()
	local onSuccess = function(eventModel )
		self.playerId = PlayerSettingData.playerId
		self.eventModel = eventModel
		self.uiScroll:Resize(self.eventModel.birthdayBossRankingInBound.listRanking:Count())
		self:_SetUserRankingItemView()
	end
	require "lua.client.core.network.event.eventBirthday.BirthdayBossRankingInBound"
	BirthdayBossRankingInBound.GetLeaderBoard(onSuccess)
end

--- @return void
function UIEventBirthdayBossLeaderboardView:InitLocalization()
	self.config.textLeaderboardTitle.text = LanguageUtils.LocalizeCommon("leaderboard")
	self.config.textTapToClose.gameObject:SetActive(false)
end

function UIEventBirthdayBossLeaderboardView:_InitButtonListener()
	self.config.bgNone.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

--- @return void
function UIEventBirthdayBossLeaderboardView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
end

