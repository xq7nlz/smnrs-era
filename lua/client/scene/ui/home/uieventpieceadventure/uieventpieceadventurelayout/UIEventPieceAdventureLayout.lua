--- @class UIEventPieceAdventureLayout : UIEventLayout
UIEventPieceAdventureLayout = Class(UIEventPieceAdventureLayout, UIEventLayout)

--- @param view UIEventPieceAdventureView
--- @param pieceAdventureTab EventPieceAdventureTab
--- @param anchor UnityEngine_RectTransform
function UIEventPieceAdventureLayout:Ctor(view, pieceAdventureTab, anchor)
    --- @type UIEventPieceAdventureView
    self.view = view
    --- @type EventPieceAdventureTab
    self.pieceAdventureTab = pieceAdventureTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventPieceAdventureModel
    self.eventModel = nil
    --- @type EventPieceAdventureConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_PIECE_ADVENTURE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventPieceAdventureLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventPieceAdventureLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventPieceAdventureLayout:SetEventBanner()
end

function UIEventPieceAdventureLayout:SetEventTitle()
end

function UIEventPieceAdventureLayout:SetEventDesc()
end

function UIEventPieceAdventureLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventPieceAdventureLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil
    self.anchor.gameObject:SetActive(false)
end

function UIEventPieceAdventureLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventPieceAdventureLayout:SetNextDayTime()
    self.onEventTimeEnded = self:OnEventTimeEnded()
    self:StartUpdateTime()
end

function UIEventPieceAdventureLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventPieceAdventureLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventPieceAdventureLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventPieceAdventureLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventPieceAdventureLayout:InitUpdateTime()
    print("need override")
end