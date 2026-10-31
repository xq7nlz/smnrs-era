
--- @class UIBossChallengeRewardView : UIBaseView
UIBossChallengeRewardView = Class(UIBossChallengeRewardView, UIBaseView)

--- @param model UIBossChallengeRewardModel
function UIBossChallengeRewardView:Ctor(model)
	--- @type UIBossChallengeRewardConfig
	self.config = nil
	---@type EventTimeData
	self.eventTime = nil

	self.localizeCurrentRanking = ""
	self.localizeSendReward = ""

	---@type BossChallengeRewardRankingConfig
	self.currentRankingReward = nil
	UIBaseView.Ctor(self, model)
	--- @type UIBossChallengeRewardModel
	self.model = model
end

function UIBossChallengeRewardView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtonListener()
	self:InitScrollView()
	self:InitUpdateTime()
end

function UIBossChallengeRewardView:InitScrollView()
	--- @param obj BossChallengeRewardItemView
	--- @param index number
	local onUpdateItem = function(obj, index)
		---@type BossChallengeRewardRankingConfig
		local data = self.listReward:Get(index + 1)
		obj:SetData(data, data == self.currentRankingReward)
	end

	--- @type UILoopScroll
	self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.BossChallengeRewardItemView, onUpdateItem, onUpdateItem)
end

function UIBossChallengeRewardView:InitButtonListener()
	self.config.buttonClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.bgClose.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
end

function UIBossChallengeRewardView:InitLocalization()
	self.config.titleReward.text = LanguageUtils.LocalizeCommon("reward")
	self.localizeCurrentRanking = LanguageUtils.LocalizeCommon("your_current_rank_x")
	self.localizeSendReward = LanguageUtils.LocalizeCommon("reward_will_sent_x")
	self.config.textTapToClose.gameObject:SetActive(false)
end

--- @param data {callbackClose : function}
function UIBossChallengeRewardView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.BossChallengeRankingInBound = data.BossChallengeRankingInBound
	--- @type EventBossChallengeModel
	self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BOSS_CHALLENGE)
	----- @type EventBossChallengeConfig
	self.eventConfig = self.eventModel:GetConfig()
	self.eventTime = self.eventModel:GetTime()
	self.listReward = self.eventConfig.listRankingReward

	self.currentRanking = self.BossChallengeRankingInBound.currentRanking
	self.rankType = self.eventConfig:GetRankingTypeByScore(self.BossChallengeRankingInBound.score)

	self:ShowArenaReward()
	self:StartTime()
end

function UIBossChallengeRewardView:ShowArenaReward()
	local indexRank = nil
	if self.currentRanking ~= nil then
		---@param v BossChallengeRewardRankingConfig
		for i, v in ipairs(self.listReward:GetItems()) do
			if (self.rankType == v.rankType) then
				self.currentRankingReward = v
				indexRank = i
				break
			end
		end
	end
	self.uiScroll:SetSize(self.listReward:Count())
	if indexRank ~= nil then
		self.uiScroll:RefillCells(math.min(indexRank - 2, self.listReward:Count() - 4))
	else
		self.uiScroll:RefillCells()
	end
end

---@return void
function UIBossChallengeRewardView:Hide()
	UIBaseView.Hide(self)
	self.uiScroll:Hide()
	self:StopTime()
end

function UIBossChallengeRewardView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self.timeFinish = self.eventTime.endTime - zg.timeMgr:GetServerTime()
		else
			self.timeFinish = self.timeFinish - 1
		end
		if self.timeFinish > 0 then
			self.config.localizeRewardWillBeSent.text = string.format(self.localizeSendReward, UIUtils.SetColorString(UIUtils.color2, TimeUtils.GetDeltaTime(self.timeFinish, 4)))
		else
			self.config.localizeRewardWillBeSent.text = ""
			self:StopTime()
		end
	end
end

--- @return void
function UIBossChallengeRewardView:StartTime()
	if self.updateTime ~= nil then
		zg.timeMgr:AddUpdateFunction(self.updateTime)
	end
end

--- @return void
function UIBossChallengeRewardView:StopTime()
	if self.updateTime ~= nil then
		zg.timeMgr:RemoveUpdateFunction(self.updateTime)
	end
end
