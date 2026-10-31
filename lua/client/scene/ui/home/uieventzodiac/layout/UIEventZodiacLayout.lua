--- @class UIEventZodiacLayout : UIEventLayout
UIEventZodiacLayout = Class(UIEventZodiacLayout, UIEventLayout)

--- @param view UIEventZodiacView
--- @param eventZodiacTab EventZodiacTab
--- @param anchor UnityEngine_RectTransform
function UIEventZodiacLayout:Ctor(view, eventZodiacTab, anchor)
    --- @type UIEventZodiacView
    self.view = view
    --- @type EventZodiacTab
    self.eventZodiacTab = eventZodiacTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventZodiacModel
    self.eventModel = nil
    --- @type EventZodiacConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_ZODIAC
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventZodiacLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventZodiacLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventZodiacLayout:SetEventBanner()
end

function UIEventZodiacLayout:SetEventTitle()
end

function UIEventZodiacLayout:SetEventDesc()
end

function UIEventZodiacLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventZodiacLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventZodiacLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil;
    self.config.backGroundCover:SetActive(false)
    self.anchor.gameObject:SetActive(false)
end

function UIEventZodiacLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




