--- @class UIEventNewVipView : UIBaseView
UIEventNewVipView = Class(UIEventNewVipView, UIBaseView)

--- @param model UIEventNewVipModel
function UIEventNewVipView:Ctor(model)
	--- @type UIEventNewVipConfig
	self.config = nil

	--- @type EventNewVipModel
	self.eventModel = nil
	---@type EventTimeType
	self.eventTimeType = EventTimeType.EVENT_NEW_VIP

	---@type List
	self.listQuestData = List()

	self.isOpen = false

	UIBaseView.Ctor(self, model)
	--- @type UIEventNewVipModel
	self.model = model
end

function UIEventNewVipView:OnReadyCreate()
	self.config = UIBaseConfig(self.uiTransform)

	self:InitButtons()
	self:InitScroll()
	self:InitUpdateTime()
end

function UIEventNewVipView:InitScroll()
	--- @param obj UIEventQuestItem
	--- @param index number
	local onCreateItem = function(obj, index)
		local dataIndex = index + 1
		--- @type QuestUnitInBound
		local questUnitInBound = self.listQuestData:Get(dataIndex)

		obj:SetData(questUnitInBound.config, questUnitInBound)
		if questUnitInBound.config:IsFeatureMappingAvailable() then
			obj:AddGoListener(function()
				self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
			end)
		end
		obj:AddClaimListener(function()
			self:OnClickClaim(questUnitInBound.questId,questUnitInBound.config._questType)
		end)
	end
	self.uiScroll = UILoopScroll(self.config.loopScrollVertical, UIPoolType.UIEventNewVipQuestItem, onCreateItem)
end

function UIEventNewVipView:OnClickGo(questId, questElementConfig)
	QuestDataInBound.GoQuest(questId, questElementConfig, function()
		PopupMgr.HidePopup(UIPopupName.UIEventNewVip)
	end)
end

function UIEventNewVipView:OnClickClaim(questId,type)
	local opcode = OpCode.EVENT_VIP_QUEST_CLAIM
	QuestDataInBound.RequestClaimQuest(opcode , questId,
			function(rewardList)
				PopupUtils.ClaimAndShowRewardList(rewardList)
				self:OnClaimQuestSuccess(questId)
			end)
end

function UIEventNewVipView:OnClaimQuestSuccess(questId)
	self.eventModel:OnClaimQuestSuccess(questId)
	self:OnUpdateListQuest()
end

function UIEventNewVipView:OnUpdateListQuest()
	self.listQuestData = self.eventModel:GetListQuestData()
	self.eventModel:SortQuestByData()
	self:FilterTabQuest()
	self.uiScroll:Resize(self.listQuestData:Count())
end


function UIEventNewVipView:InitButtons()
	self.config.bg.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.backButton.onClick:AddListener(function ()
		self:OnClickBackOrClose()
	end)
	self.config.buttonShop.onClick:AddListener(function ()
		zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
		TrackingUtils.AddFireBaseClickMainArea(FBEvents.MAIN_FEATURES, "iap_shop")
		PopupMgr.ShowAndHidePopup(UIPopupName.UIIapShop, nil, self.model.uiName)
	end)
end

function UIEventNewVipView:InitLocalization()
	self.config.textEventTitle.text = LanguageUtils.LocalizeCommon("event_vip_treasure")
	self.config.textEventContent.text = LanguageUtils.LocalizeCommon("event_vip_treasure_content")
	self.config.textShop.text = LanguageUtils.LocalizeCommon("go_to_store")
end


function UIEventNewVipView:OnReadyHide()

end

--- @param data {callbackClose : function}
function UIEventNewVipView:OnReadyShow(data)
	UIBaseView.OnReadyShow(self, data)
	self:GetModelConfig()
	self.isReloadingData = false
	self.isOpen = self.eventModel:IsOpening()
	if self.isOpen then
		self.eventListener = RxMgr.eventStateChange:Subscribe(RxMgr.CreateFunction(self, self.OnEventStateChange))
	end
	self.listQuestData = self.eventModel.listQuestData
	self.eventModel:SortQuestByData()
	self.uiScroll:Resize(self.listQuestData:Count())
	self:SetEndEventTime(self:_GetEventEndTime(), function()
		self:_OnEventTimeEnded()
	end)
end

function UIEventNewVipView:FilterTabQuest()
	local questCount = self.listQuestData:Count()
	for i = questCount, 1, -1 do
		--- @type QuestUnitInBound
		local questUnitData = self.listQuestData:Get(i)
		if questUnitData.questState == QuestState.HIDDEN then
			self.listQuestData:RemoveByIndex(i)
		end
	end
end

--- @param data {eventTimeType : EventTimeType, isAdded}
function UIEventNewVipView:OnEventStateChange(data)
	local isAdded = data.isAdded
	if isAdded == false and self.isReloadingData ~= true then
		self.isReloadingData = true
		EventInBound.ValidateEventModel(function()
			---@type EventNewVipModel
			local eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
			if eventModel:IsOpening() then
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

function UIEventNewVipView:RemoveListener()
	if self.eventListener ~= nil then
		self.eventListener:Unsubscribe()
		self.eventListener = nil
	end
end

function UIEventNewVipView:OnReadyHide()
	PopupMgr.ShowAndHidePopup(UIPopupName.UIMainArea, nil, self.model.uiName)
end


function UIEventNewVipView:Hide()
	UIBaseView.Hide(self)
	self:RemoveListener()
	self:RemoveUpdateTime()
end

function UIEventNewVipView:GetModelConfig()
	self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
	if self.eventModel ~= nil then
		self.eventConfig = self.eventModel:GetConfig()
	end
end

function UIEventNewVipView:_GetEventEndTime()
	return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventNewVipView:SetEndEventTime(endTime, onEventTimeEnded)
	self.endTime = endTime
	self.onEventTimeEnded = onEventTimeEnded
	self:StartUpdateTime()
end

function UIEventNewVipView:StartUpdateTime()
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventNewVipView:RemoveUpdateTime()
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventNewVipView:SetTimeRefresh()
	self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventNewVipView:_OnEventTimeEnded()
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = self.eventTimeType, ["isAdded"] = false })
end

function UIEventNewVipView:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		self.config.textEventTime.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_end_in"),
				UIUtils.SetColorString(UIUtils.green_normal, TimeUtils.GetDeltaTime(self.timeRefresh)))
		if self.timeRefresh <= 0 then
			self:RemoveUpdateTime()
			if self.onEventTimeEnded then
				self.onEventTimeEnded()
			end
		end
	end
end
