--- @class UIEventBlackFridayLayout : UIEventLayout
UIEventBlackFridayLayout = Class(UIEventBlackFridayLayout, UIEventLayout)

--- @param view UIEventBlackFridayView
--- @param blackFridayTab BlackFridayTab
--- @param anchor UnityEngine_RectTransform
function UIEventBlackFridayLayout:Ctor(view, blackFridayTab, anchor)
    --- @type UIEventBlackFridayView
    self.view = view
    --- @type BlackFridayTab
    self.blackFridayTab = blackFridayTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventBlackFridayModel
    self.eventBlackFridayModel = nil
    --- @type EventBlackFridayConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_BLACK_FRIDAY)
    self:InitLayoutConfig()

end

--- @param objectView UnityEngine_GameObject
function UIEventBlackFridayLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventBlackFridayLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBlackFridayLayout:SetEventBanner()
end

function UIEventBlackFridayLayout:SetEventTitle()
end

function UIEventBlackFridayLayout:SetEventDesc()
end

function UIEventBlackFridayLayout:InitButtons()
end

function UIEventBlackFridayLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventBlackFridayLayout:GetModelConfig()
    self.eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    if self.eventBlackFridayModel ~= nil then
        self.eventConfig = self.eventBlackFridayModel:GetConfig()
    end
end