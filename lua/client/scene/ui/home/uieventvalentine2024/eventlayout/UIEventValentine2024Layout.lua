--- @class UIEventValentine2024Layout : UIEventLayout
UIEventValentine2024Layout = Class(UIEventValentine2024Layout, UIEventLayout)

--- @param view UIEventValentine2024View
--- @param tab Valentine2024Tab
--- @param anchor UnityEngine_RectTransform
function UIEventValentine2024Layout:Ctor(view, tab, anchor)
    --- @type UIEventValentine2024View
    self.view = view
    --- @type Valentine2024Tab
    self.tab = tab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventValentine2024Model
    self.eventModel = nil
    --- @type EventValentine2024Config
    self.eventConfig = nil
    UIEventLayout.Ctor(self, view, EventTimeType.EVENT_VALENTINE_2024)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventValentine2024Layout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventValentine2024Layout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventValentine2024Layout:SetEventBanner()
end

function UIEventValentine2024Layout:SetEventTitle()
end

function UIEventValentine2024Layout:SetEventDesc()
end

function UIEventValentine2024Layout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventValentine2024Layout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE_2024)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end