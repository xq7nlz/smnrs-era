--- @class UIEventLunarPathLayout : UIEventLayout
UIEventLunarPathLayout = Class(UIEventLunarPathLayout, UIEventLayout)

--- @param view UIEventLunarPathView
--- @param lunarPathTab LunarPathTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarPathLayout:Ctor(view, lunarPathTab, anchor)
    --- @type UIEventLunarPathView
    self.view = view
    --- @type LunarPathTab
    self.lunarPathTab = lunarPathTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventLunarPathModel
    self.eventModel = nil
    --- @type EventLunarPathConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_LUNAR_PATH
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventLunarPathLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventLunarPathLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarPathLayout:SetEventBanner()

end

function UIEventLunarPathLayout:SetEventTitle()

end

function UIEventLunarPathLayout:SetEventDesc()

end

function UIEventLunarPathLayout:OnShow()
    self:GetModelConfig()
    self.layoutConfig.gameObject:SetActive(true)
    UIEventLayout.OnShow(self)
end

function UIEventLunarPathLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventLunarPathLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.layoutConfig.gameObject:SetActive(false)
end
