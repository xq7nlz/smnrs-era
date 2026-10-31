--- @class UIEventSeasonalLayout : UIEventLayout
UIEventSeasonalLayout = Class(UIEventSeasonalLayout, UIEventLayout)

--- @param view UIEventSeasonalView
--- @param eventSeasonalTab EventSeasonalTab
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalLayout:Ctor(view, eventSeasonalTab, anchor)
    --- @type UIEventSeasonalView
    self.view = view
    --- @type EventSeasonalTab
    self.eventSeasonalTab = eventSeasonalTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventSeasonalModel
    self.eventModel = nil
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_SEASONAL
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
    self:InitButtonListener()
end

--- @param objectView UnityEngine_GameObject
function UIEventSeasonalLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventSeasonalLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventSeasonalLayout:SetEventBanner()
end

function UIEventSeasonalLayout:InitButtonListener()
end

function UIEventSeasonalLayout:SetEventTitle()
end

function UIEventSeasonalLayout:SetEventDesc()
end

function UIEventSeasonalLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventSeasonalLayout:OnShow()
    UIEventLayout.OnShow(self)
    self:InitLocalization()
    self:GetModelConfig()
end

function UIEventSeasonalLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventSeasonalLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil
    self.view.config.backGroundCover:SetActive(false)
    self.anchor.gameObject:SetActive(false)
end

function UIEventSeasonalLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




