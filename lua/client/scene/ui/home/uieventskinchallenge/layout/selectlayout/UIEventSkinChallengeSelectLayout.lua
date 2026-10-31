require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.selectLayout.SkinSelectItemView"
require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.UIEventSkinChallengeLayout"
--- @class UIEventSkinChallengeSelectLayout : UIEventSkinChallengeLayout
UIEventSkinChallengeSelectLayout = Class(UIEventSkinChallengeSelectLayout, UIEventSkinChallengeLayout)

--- @param view UIEventZodiacView
--- @param eventSkinChallengeTab EventSkinChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIEventSkinChallengeSelectLayout:Ctor(view, eventSkinChallengeTab, anchor)
	--- @type UIEventChallengeSelectLayoutConfig
	self.layoutConfig = nil
	UIEventSkinChallengeLayout.Ctor(self, view,eventSkinChallengeTab,anchor)
	--- @type List
	self.listSkinSelectItem = List()
	--- @type List
	self.listSkinSelect = List()
end

function UIEventSkinChallengeSelectLayout:InitLayoutConfig()
	local inst = PrefabLoadUtils.Instantiate("ui_event_skin_challenge_select_layout", self.anchor)
	UIEventSkinChallengeLayout.InitLayoutConfig(self, inst)
	self:InitListeners()
	self:InitUpdateTime()
end

function UIEventSkinChallengeSelectLayout:InitListeners()
	self.layoutConfig.buttonBack.onClick:AddListener(function()
		zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
		if self.eventModel.selectionId ~= 0 then
			self:CloseLayout()
		else
			self.view.layout = nil
			self.anchor.gameObject:SetActive(false)
			self:RemoveUpdateTime()
			self.view:OnClickBackOrClose()
		end
	end)
end


function UIEventSkinChallengeSelectLayout:OnShow()
	UIEventSkinChallengeLayout.OnShow(self)
	self:SetEventTitle()
	self:SetEndEventTime(self:_GetEventEndTime(), function()
		self:_OnEventTimeEnded()
	end)
	--self:ShowSkin()
end

function UIEventSkinChallengeSelectLayout:ShowSkin()
	self.listSkinSelect = self.eventConfig:GetSelectSkinConfig()
	local count = self.layoutConfig.itemAnchor.childCount
	local skinId = nil
	local item = nil
	for i = 0, count - 1 do
		--- @type SkinSelectItemView
		item = SkinSelectItemView(self.layoutConfig.itemAnchor:GetChild(i))
		skinId = self.listSkinSelect:Get(i + 1)
		item:SetIconData(i + 1, skinId, self.eventModel.timeData.dataId, function(id)
			self:OnSelect(id)
		end)
		self.listSkinSelectItem:Add(item)
	end
end

function UIEventSkinChallengeSelectLayout:OnSelect(id)
	local onReceived = function(result)
		--- @param buffer UnifiedNetwork_ByteBuf
		local onBufferReading = function(buffer)

		end
		local onFailed = function(logicCode)
			SmartPoolUtils.LogicCodeNotification(logicCode)
		end
		local onSuccess = function()
			self.eventModel.selectionId = id
			self:CloseLayout()
		end
		NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
	end

	PopupUtils.ShowPopupNotificationTwoButtons(LanguageUtils.LocalizeCommon("confirm_select_skin"),nil,function()
		NetworkUtils.Request(OpCode.EVENT_SKIN_CHALLENGE_SELECTION_SKIN, UnknownOutBound.CreateInstance(PutMethod.Int, id),
				onReceived)
	end, nil, "no", "ok")

end


function UIEventSkinChallengeSelectLayout:SetEventTitle()
	self.layoutConfig.title.text = LanguageUtils.LocalizeCommon("back")
	--self.layoutConfig.title.gameObject:SetActive(false)
	self.layoutConfig.textMainTitle.text =UIUtils.SetColorString(UIUtils.white, LanguageUtils.LocalizeCommon("title_event_skin_challenge"))
	--self.layoutConfig.textMainTitle.color = UIUtils.white
	local selectText = LanguageUtils.LocalizeCommon("please_select_1_skin")
	selectText = string.gsub(selectText,"{1}",UIUtils.SetColorString(UIUtils.green_dark,"1"))
	self.layoutConfig.textSelect.text = selectText
end




function UIEventSkinChallengeSelectLayout:OnHide()
	UIEventSkinChallengeLayout.OnHide(self)
	self.listSkinSelectItem:Clear()
end

function UIEventSkinChallengeSelectLayout:_GetEventEndTime()
	return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSkinChallengeSelectLayout:SetEndEventTime(endTime, onEventTimeEnded)
	self.endTime = endTime
	self.onEventTimeEnded = onEventTimeEnded
	self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSkinChallengeSelectLayout:_OnEventTimeEnded(eventTimeType)
	RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSkinChallengeSelectLayout:StartUpdateTime()
	zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeSelectLayout:RemoveUpdateTime()
	zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeSelectLayout:SetTimeRefresh()
	self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinChallengeSelectLayout:InitUpdateTime()
	--- @param isSetTime boolean
	self.updateTime = function(isSetTime)
		if isSetTime == true then
			self:SetTimeRefresh()
		else
			self.timeRefresh = self.timeRefresh - 1
		end
		self.layoutConfig.textEventTime.text = string.format("%s %s",LanguageUtils.LocalizeCommon("will_end_in"),
				UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
		if self.timeRefresh <= 0 then
			self:RemoveUpdateTime()
			if self.onEventTimeEnded then
				self.onEventTimeEnded()
			end
		end
	end
end



