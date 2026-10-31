--- @class UIEventNewYear2023Layout : UIEventLayout
UIEventNewYear2023Layout = Class(UIEventNewYear2023Layout, UIEventLayout)

--- @param view UIEventNewYear2023View
--- @param tab NewYear2023Tab
--- @param anchor UnityEngine_RectTransform
function UIEventNewYear2023Layout:Ctor(view, tab, anchor)
    --- @type UIEventNewYear2023View
    self.view = view
    --- @type NewYear2023Tab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventNewYear2023Model
    self.eventModel = nil
    --- @type EventNewYear2023Config
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_NEW_YEAR_2023)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventNewYear2023Layout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventNewYear2023Layout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventNewYear2023Layout:SetEventBanner()
end

function UIEventNewYear2023Layout:SetEventTitle()
end

function UIEventNewYear2023Layout:SetEventDesc()
end

function UIEventNewYear2023Layout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventNewYear2023Layout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_YEAR_2023)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end