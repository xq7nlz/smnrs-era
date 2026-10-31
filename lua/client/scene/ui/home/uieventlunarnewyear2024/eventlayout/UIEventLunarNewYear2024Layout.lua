--- @class UIEventLunarNewYear2024Layout : UIEventLayout
UIEventLunarNewYear2024Layout = Class(UIEventLunarNewYear2024Layout, UIEventLayout)

--- @param view UIEventLunarNewYear2024View
--- @param tab LunarNewYear2024Tab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarNewYear2024Layout:Ctor(view, tab, anchor)
    --- @type UIEventLunarNewYear2024View
    self.view = view
    --- @type LunarNewYear2024Tab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventLunarNewYear2024Model
    self.eventModel = nil
    --- @type EventLunarNewYear2024Config
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventLunarNewYear2024Layout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventLunarNewYear2024Layout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarNewYear2024Layout:SetEventBanner()
end

function UIEventLunarNewYear2024Layout:SetEventTitle()
end

function UIEventLunarNewYear2024Layout:SetEventDesc()
end

function UIEventLunarNewYear2024Layout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventLunarNewYear2024Layout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_LUNAR_NEW_YEAR_2024)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end