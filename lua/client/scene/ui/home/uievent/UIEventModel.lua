--- @class UIEventModel : UIBaseModel
UIEventModel = Class(UIEventModel, UIBaseModel)

--- @return void
function UIEventModel:Ctor()
    UIBaseModel.Ctor(self, UIPopupName.UIEvent, "ui_event")
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

function UIEventModel:GetData()
    self:SetEventDataList()
    if self.eventDataList:Count() > 0 then
        --- @type EventPopupModel
        local eventPopupModel = self.eventDataList:Get(1)
        self:SetTab(eventPopupModel.timeData.eventType)
    else
        self:SetTab(EventTimeType.COMMUNITY_TYPE)
    end
end

--- @param eventTimeType EventTimeType
function UIEventModel:SetTab(eventTimeType)
    self.currentTab = eventTimeType
    self.currentEventModel = self.eventDataDict:Get(eventTimeType)
end

--- @return boolean
function UIEventModel:IsCurrentTab(eventTimeType)
    return self.currentTab == eventTimeType
end

function UIEventModel:SetEventDataList()
    self.eventDataList = List()
    self.eventDataDict = Dictionary()
    --- @type EventInBound
    self.eventInBound = zg.playerData:GetEvents()

    --- @param eventTimeType EventTimeType
    --- @param eventPopupModel EventPopupModel
    for eventTimeType, eventPopupModel in pairs(self.eventInBound:GetAllEvents():GetItems()) do
        if eventPopupModel:IsOpening() and EventTimeType.IsEventPopup(eventTimeType) then
            self.eventDataList:Add(eventPopupModel)
            self.eventDataDict:Add(eventTimeType, eventPopupModel)
        end
    end
end

function UIEventModel:RemoveEventByType(eventTimeType)
    self.currentTab = nil
    local eventPopupModel = self.eventDataDict:Get(eventTimeType)
    if eventPopupModel ~= nil then
        self.eventDataList:RemoveByReference(eventPopupModel)
        self.eventDataDict:RemoveByKey(eventTimeType)
    end
    self.eventInBound:RemoveEventByType(eventTimeType)
end