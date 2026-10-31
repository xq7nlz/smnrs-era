--- @class UIEventValentineLayout : UIEventLayout
UIEventValentineLayout = Class(UIEventValentineLayout, UIEventLayout)

--- @param view UIEventNewYearView
--- @param valentineTab ValentineTab
--- @param anchor UnityEngine_RectTransform
function UIEventValentineLayout:Ctor(view, valentineTab, anchor)
    --- @type UIEventValentineView
    self.view = view
    --- @type ValentineTab
    self.valentineTab = valentineTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventValentineModel
    self.eventModel = nil
    --- @type EventValentineConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_VALENTINE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventValentineLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventValentineLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventValentineLayout:SetEventBanner()
end

function UIEventValentineLayout:SetEventTitle()
end

function UIEventValentineLayout:SetEventDesc()
end

function UIEventValentineLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventValentineLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventValentineLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




