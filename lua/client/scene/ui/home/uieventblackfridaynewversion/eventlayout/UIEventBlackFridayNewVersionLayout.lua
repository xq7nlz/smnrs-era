
--- @class UIEventBlackFridayNewVersionLayout : UIEventLayout
UIEventBlackFridayNewVersionLayout = Class(UIEventBlackFridayNewVersionLayout, UIEventLayout)

--- @param view UIEventBlackFridayNewVersionView
--- @param eventBlackFridayNewTab EventBlackFridayNewVersionTab
--- @param anchor UnityEngine_RectTransform
function UIEventBlackFridayNewVersionLayout:Ctor(view, eventBlackFridayNewTab, anchor)
    --- @type UIEventBlackFridayNewVersionView
    self.view = view
    --- @type EventBlackFridayNewVersionTab
    self.eventTab = eventBlackFridayNewTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventBlackFridayNewVersionModel
    self.eventModel = nil
    --- @type EventBlackFridayNewVersionConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BLACK_FRIDAY_SALE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventBlackFridayNewVersionLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventBlackFridayNewVersionLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBlackFridayNewVersionLayout:SetEventBanner()
end

function UIEventBlackFridayNewVersionLayout:SetEventTitle()
end

function UIEventBlackFridayNewVersionLayout:SetEventDesc()
end

function UIEventBlackFridayNewVersionLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventBlackFridayNewVersionLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventBlackFridayNewVersionLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    end, true)
    self.view.layout = nil
    self.anchor.gameObject:SetActive(false)
end

function UIEventBlackFridayNewVersionLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventBlackFridayNewVersionLayout:SetNextDayTime()
    self.onEventTimeEnded = self:OnEventTimeEnded()
    self:StartUpdateTime()
end

function UIEventBlackFridayNewVersionLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventBlackFridayNewVersionLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventBlackFridayNewVersionLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventBlackFridayNewVersionLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventBlackFridayNewVersionLayout:InitUpdateTime()
    print("need override")
end




