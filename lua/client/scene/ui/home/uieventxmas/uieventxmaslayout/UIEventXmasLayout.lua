--- @class UIEventXmasLayout : UIEventLayout
UIEventXmasLayout = Class(UIEventXmasLayout, UIEventLayout)

--- @param view UIEventXmasView
--- @param xmasTab XmasTab
--- @param anchor UnityEngine_RectTransform
function UIEventXmasLayout:Ctor(view, xmasTab, anchor)
    --- @type UIEventXmasView
    self.view = view
    --- @type XmasTab
    self.xmasTab = xmasTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventXmasModel
    self.eventModel = nil
    --- @type EventXmasConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_XMAS)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventXmasLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventXmasLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventXmasLayout:SetEventBanner()
end

function UIEventXmasLayout:SetEventTitle()
end

function UIEventXmasLayout:SetEventDesc()
end

function UIEventXmasLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventXmasLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_XMAS)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end