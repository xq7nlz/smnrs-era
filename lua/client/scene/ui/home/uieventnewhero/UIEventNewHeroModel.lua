
--- @class UIEventNewHeroModel : UIBaseModel
UIEventNewHeroModel = Class(UIEventNewHeroModel, UIBaseModel)

--- @return void
function UIEventNewHeroModel:Ctor()
	UIBaseModel.Ctor(self, UIPopupName.UIEventNewHero, "ui_event_new_hero")
	--- @type UIPopupType
	self.type = UIPopupType.NO_BLUR_POPUP

	--- @type EventTimeType
	self.currentTab = nil
	--- @type EventPopupModel
	self.currentEventModel = nil

	--- @type List
	self.eventDataList = nil
	--- @type Dictionary
	self.eventDataDict = nil

	--- @type EventInBound
	self.eventInBound = nil
end

function UIEventNewHeroModel:GetData()
	self:SetEventDataList()
	if self.eventDataList:Count() > 0 then
		--- @type EventPopupModel
		local eventPopupModel = self.eventDataList:Get(1)
		self:SetTab(eventPopupModel.timeData.eventType)
	end
end

--- @param eventTimeType EventTimeType
function UIEventNewHeroModel:SetTab(eventTimeType)
	self.currentTab = eventTimeType
	self.currentEventModel = self.eventDataDict:Get(eventTimeType)
end

--- @return boolean
function UIEventNewHeroModel:IsCurrentTab(eventTimeType)
	return self.currentTab == eventTimeType
end

function UIEventNewHeroModel:SetEventDataList()
	self.eventDataList = List()
	self.eventDataDict = Dictionary()
	--- @type EventInBound
	self.eventInBound = zg.playerData:GetEvents()

	--- @param eventTimeType EventTimeType
	--- @param eventPopupModel EventPopupModel
	for eventTimeType, eventPopupModel in pairs(self.eventInBound:GetAllEvents():GetItems()) do
		if eventPopupModel:IsOpening() and EventTimeType.IsEventNewHero(eventTimeType) then
			self.eventDataList:Add(eventPopupModel)
			self.eventDataDict:Add(eventTimeType, eventPopupModel)
		end
	end
end

function UIEventNewHeroModel:RemoveEventByType(eventTimeType)
	self.currentTab = nil
	local eventPopupModel = self.eventDataDict:Get(eventTimeType)
	if eventPopupModel ~= nil then
		self.eventDataList:RemoveByReference(eventPopupModel)
		self.eventDataDict:RemoveByKey(eventTimeType)
	end
	self.eventInBound:RemoveEventByType(eventTimeType)
end