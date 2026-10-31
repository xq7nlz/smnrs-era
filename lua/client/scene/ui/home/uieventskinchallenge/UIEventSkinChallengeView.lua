--- @class UIEventSkinChallengeView : UIBaseView
UIEventSkinChallengeView = Class(UIEventSkinChallengeView, UIBaseView)

--- @param model UIEventZodiacModel
function UIEventSkinChallengeView:Ctor(model)
	--- @type UIEventSkinChallengeConfig
	self.config = nil
	--- @type Dictionary
	self.layoutDict = Dictionary()
	--- @type UIEventSkinChallengeLayout
	self.layout = nil
	--- @type Dictionary
	self.eventTabDict = Dictionary()

	--- @type EventSkinChallengeModel
	self.eventModel = nil
	--- @type EventSkinChallengeConfig
	self.eventConfig = nil
	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_SKIN_CHALLENGE
	--- @type boolean
	self.isReloadingData = nil

	UIBaseView.Ctor(self, model)
	--- @type UIEventZodiacModel
	self.model = model
end

function UIEventSkinChallengeView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)
	self:InitButtons()
	self:InitUpdateTime()
end

function UIEventSkinChallengeView:InitButtons()
	self.config.buttonBack.onClick:AddListener(function()
		self:OnClickBackOrClose()
	end)
	self.config.buttonAsk.onClick:AddListener(function()
		self:OnClickHelpInfo()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
	self.config.challengeButton.onClick:AddListener(function()
		self:ShowFormation()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
	end)
end

function UIEventSkinChallengeView:InitLocalization()
	self.config.textTitle.text = LanguageUtils.LocalizeCommon("title_event_skin_challenge")
	self.config.textChallenge.text = LanguageUtils.LocalizeCommon("challenges")
	if self.layoutDict ~= nil then
		--- @param v UIEventZodiacLayout
		for _, v in pairs(self.layoutDict:GetItems()) do
			v:InitLocalization()
		end
	end

end

function UIEventSkinChallengeView:InitEventButtons()
	for skinChallengeTab = 1, self.model.listSubEvent:Count() do
		local eventButton = self.config.listEventButtons.transform:GetChild(skinChallengeTab - 1)
		--- @type UIEventSubButtonItem
		local eventSubButtonItem = UIEventSubButtonItem(eventButton)
		eventSubButtonItem:SetConfig(eventButton)

		eventSubButtonItem:SetText(self:_GetEventName(skinChallengeTab))
		eventSubButtonItem:SetNotificationFunction(function()
			return self:_GetEventNotification(skinChallengeTab)
		end)
		eventSubButtonItem:AddOnSelectListener(function()
			self:OnClickSelectTab(skinChallengeTab)
		end)
		self.eventTabDict:Add(skinChallengeTab, eventSubButtonItem)
	end
end

function UIEventSkinChallengeView:OnClickBackOrClose()
	zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
	if self.layout ~= nil and self.layout.config.gameObject.activeInHierarchy then
		if self.layout.eventSkinChallengeTab ~= EventSkinChallengeTab.SELECT then
			self:HideCurrentLayout()
			return
		end
	end
	self:OnReadyHide()
end

function UIEventSkinChallengeView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

--- @param data {callbackClose : function}
function UIEventSkinChallengeView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self.isReloadingData = false
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	self.eventConfig = self.eventModel:GetConfig()
	self.isOpen = self.eventModel:IsOpening()
	if self.isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	self.model:InitListSubEvent(self.eventModel.timeData)
	self:SetEndEventTime(self:_GetEventEndTime(), function()
		self:_OnEventTimeEnded()
	end)
	self:InitEventButtons()
	if self.eventModel.selectionId == 0 then
		self:SelectTab(EventSkinChallengeTab.SELECT)
	end
	self:CheckAllNotificationTab()
end

function UIEventSkinChallengeView:SelectTab(eventSkinChallengeTab)
	self:GetLayout(eventSkinChallengeTab)
	self.layout:OnShow(self)
end

function UIEventSkinChallengeView:OnClickSelectTab(eventSkinChallengeTab)
	self:SelectTab(eventSkinChallengeTab)
end

--- @param eventSkinChallengeTab EventSkinChallengeTab
function UIEventSkinChallengeView:GetLayout(eventSkinChallengeTab)
	self:DisableCommon()
	self.layout = self.layoutDict:Get(eventSkinChallengeTab)
	if self.layout == nil then
		if eventSkinChallengeTab == EventSkinChallengeTab.SELECT then
			require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.selectLayout.UIEventSkinChallengeSelectLayout"
			self.layout = UIEventSkinChallengeSelectLayout(self, eventSkinChallengeTab, self.config.selectAnchor)
		elseif eventSkinChallengeTab == EventSkinChallengeTab.QUEST then
			require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.questLayout.UIEventSkinChallengeQuestLayout"
			self.layout = UIEventSkinChallengeQuestLayout(self, eventSkinChallengeTab, self.config.questAnchor)
		elseif eventSkinChallengeTab == EventSkinChallengeTab.EXCHANGE then
			require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.exchangeLayout.UIEventSkinChallengeExchangeLayout"
			self.layout = UIEventSkinChallengeExchangeLayout(self, eventSkinChallengeTab, self.config.exchangeAnchor)
		elseif eventSkinChallengeTab == EventSkinChallengeTab.BUNDLE then
			require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.bundleLayout.UIEventSkinChallengeBundleLayout"
			self.layout = UIEventSkinChallengeBundleLayout(self, eventSkinChallengeTab, self.config.bundleAnchor)
		else
			return nil
		end
		self.layoutDict:Add(eventSkinChallengeTab, self.layout)
	end
end

function UIEventSkinChallengeView:DisableCommon()
	self:HideCurrentLayout()
end

function UIEventSkinChallengeView:OnClickHelpInfo()
	PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_skin_challenge_info"))
end

--- @param eventSkinChallengeTab EventSkinChallengeTab
function UIEventSkinChallengeView:_GetEventName(eventSkinChallengeTab)
	if eventSkinChallengeTab == EventSkinChallengeTab.QUEST then
		return LanguageUtils.LocalizeCommon("progress")
	else
		return LanguageUtils.LocalizeCommon("disband")
	end
end

--- @param eventSkinChallengeTab EventSkinChallengeTab
function UIEventSkinChallengeView:_GetEventNotification(eventSkinChallengeTab)
	return self.eventModel:IsTabNotified(eventSkinChallengeTab)
end

function UIEventSkinChallengeView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

--- @param eventSkinChallengeTab EventSkinChallengeTab
function UIEventSkinChallengeView:UpdateNotificationByTab(eventSkinChallengeTab)
	--- @type UIEventSubButtonItem
	local objTab = self.eventTabDict:Get(eventSkinChallengeTab)
	if objTab ~= nil then
		objTab:UpdateNotification()
	end
end

function UIEventSkinChallengeView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end

function UIEventSkinChallengeView:CheckAllNotificationTab()
	--- @param v EventSkinChallengeTab
	--- @param v UIEventSubButtonItem
	for k, v in pairs(self.eventTabDict:GetItems()) do
		self:UpdateNotificationByTab(k)
	end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventSkinChallengeView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventZodiacModel
			local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
			if eventModel:IsOpening() then
				self:HideCurrentLayout()
				self:RemoveListener()
				self:OnReadyShow()
			else
				if PopupUtils.IsPopupShowing(self.model.uiName) == false then
					return
				end
				PopupMgr.HidePopup(self.model.uiName)
				PopupMgr.ShowPopup(UIPopupName.UIMainArea)
				SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("event_has_ended"))
			end
		end, true)
	end
end

function UIEventSkinChallengeView:Hide()
	UIBaseView.Hide(self)

	self:RemoveListener()
	self:RemoveUpdateTime()

	self:HideCurrentLayout()
end

function UIEventSkinChallengeView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventSkinChallengeView:HideCurrentLayout()
	if self.layout ~= nil then
		self.layout:OnHide()
		self.layout = nil
	end
end

function UIEventSkinChallengeView:_GetEventEndTime()
	return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSkinChallengeView:SetEndEventTime(endTime, onEventTimeEnded)
	self.endTime = endTime
	self.onEventTimeEnded = onEventTimeEnded
	self:StartUpdateTime()
end

function UIEventSkinChallengeView:StartUpdateTime()
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeView:RemoveUpdateTime()
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeView:SetTimeRefresh()
	self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinChallengeView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		self.config.textEventTime.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_end_in"),
				UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
		if self.timeRefresh <= 0 then
			self:RemoveUpdateTime()
			if self.onEventTimeEnded then
				self.onEventTimeEnded()
			end
		end
	end
end


--- @return void
function UIEventSkinChallengeView:ShowFormation()
	---@type DefenderTeamData
	local dataStage = self.eventConfig:GetListLineupRecommendation(self.eventModel.randomDefenderTeamId)
	---@type BattleTeamInfo
	local battleTeamInfo = ResourceMgr.GetServiceConfig():GetPredefineTeam():GetBattleTeamInfoByDefenderTeamData(dataStage)
	--- @type {gameMode, battleTeamInfo, callbackPlayBattle, callbackClose}
	local result = {}
	result.gameMode = GameMode.EVENT_SKIN_CHALLENGE
	result.battleTeamInfo = battleTeamInfo
	result.powerDefenderTeam = dataStage:GetPowerTeam()
	result.callbackClose = function()
		PopupMgr.HidePopup(UIPopupName.UIFormation)
		local data = {}
		--data.tab = EventSkinChallengeTab.QUEST
		PopupMgr.ShowPopup(self.model.uiName, data)
	end
	result.callbackPlayBattle = function(uiFormationTeamData, callback)
		--- @type List
		local listReward = List()
		--- @type BattleResultInBound
		local battleResultInBound = nil
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)
			self:GetModelConfig()
			battleResultInBound = BattleResultInBound.CreateByBuffer(buffer)
			local rewards = NetworkUtils.GetRewardInBoundList(buffer)
			for i = 1, rewards:Count() do
				listReward:Add(rewards:Get(i):GetIconData())
			end
		end
		local callbackSuccess = function()
			EventInBound.ValidateEventModel(function()
				self:GetModelConfig()
			end, true)
			if battleResultInBound.isWin then
				zg.playerData.rewardList = listReward
				zg.playerData:AddListRewardToInventory()
			end
			RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
			zg.audioMgr:PlaySfxUi(SfxUiType.START_BATTLE)
			if callback ~= nil then
				callback()
			end
		end
		NetworkUtils.RequestAndCallback(OpCode.EVENT_SKIN_CHALLENGE_BATTLE ,
				BattleFormationOutBound(uiFormationTeamData),
				callbackSuccess,
				SmartPoolUtils.LogicCodeNotification, onBufferReading)
	end
	PopupMgr.HidePopup(self.model.uiName)
	PopupMgr.ShowPopup(UIPopupName.UIFormation, result)
end

function UIEventSkinChallengeView:GetModelConfig()
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	if self.eventModel ~= nil then
		self.eventConfig = self.eventModel:GetConfig()
	end
end