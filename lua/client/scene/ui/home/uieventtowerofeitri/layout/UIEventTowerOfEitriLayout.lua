--- @class UIEventTowerOfEitriLayout : UIEventLayout
UIEventTowerOfEitriLayout = Class(UIEventTowerOfEitriLayout, UIEventLayout)

--- @param view UIEventTowerOfEitriView
--- @param eventTowerOfEitriTab EventTowerOfEitriTab
--- @param anchor UnityEngine_RectTransform
function UIEventTowerOfEitriLayout:Ctor(view, eventTowerOfEitriTab, anchor)
    --- @type UIEventTowerOfEitriView
    self.view = view
    --- @type EventTowerOfEitriTab
    self.eventTowerOfEitriTab = eventTowerOfEitriTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventTowerOfEitriModel
    self.eventModel = nil
    --- @type EventTowerOfEitriConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventTowerOfEitriLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventTowerOfEitriLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventTowerOfEitriLayout:SetEventBanner()
end

function UIEventTowerOfEitriLayout:SetEventTitle()
end

function UIEventTowerOfEitriLayout:SetEventDesc()
end

function UIEventTowerOfEitriLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventTowerOfEitriLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventTowerOfEitriLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventTowerOfEitriLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil
    self.view.config.backGroundCover.enabled = false
    self.anchor.gameObject:SetActive(false)
end

function UIEventTowerOfEitriLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end


function UIEventTowerOfEitriLayout:SetNextDayTime()
    self.onEventTimeEnded = self:OnEventTimeEnded()
    self:StartUpdateTime()
end

function UIEventTowerOfEitriLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventTowerOfEitriLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventTowerOfEitriLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventTowerOfEitriLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventTowerOfEitriLayout:InitUpdateTime()
    print("need override")
end




