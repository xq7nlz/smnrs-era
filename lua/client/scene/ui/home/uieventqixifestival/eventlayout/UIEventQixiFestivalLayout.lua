--- @class UIEventQixiFestivalLayout : UIEventLayout
UIEventQixiFestivalLayout = Class(UIEventQixiFestivalLayout, UIEventLayout)

--- @param view UIEventQixiFestivalView
--- @param tab QixiFestivalTab
--- @param anchor UnityEngine_RectTransform
function UIEventQixiFestivalLayout:Ctor(view, tab, anchor)
    --- @type UIEventQixiFestivalView
    self.view = view
    --- @type QixiFestivalTab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventQixiFestivalModel
    self.eventModel = nil
    --- @type EventQixiFestivalConfig
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_QIXI)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventQixiFestivalLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventQixiFestivalLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventQixiFestivalLayout:SetEventBanner()
end

function UIEventQixiFestivalLayout:SetEventTitle()
end

function UIEventQixiFestivalLayout:SetEventDesc()
end

function UIEventQixiFestivalLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventQixiFestivalLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_QIXI)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end