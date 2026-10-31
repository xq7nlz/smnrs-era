--- @class UIEventLayout
UIEventLayout = Class(UIEventLayout)

--- @param view UIEventView
--- @param eventTimeType EventTimeType
function UIEventLayout:Ctor(view, eventTimeType)
    --- @type UIEventView
    self.view = view
    --- @type UIEventModel
    self.model = view.model
    --- @type UIEventConfig
    self.config = view.config
    --- @type EventTimeType
    self.eventTimeType = eventTimeType
end

function UIEventLayout:InitLocalization()
end

function UIEventLayout:ResizeLoopScrollContent(size)
    self.config.VerticalScrollContent.gameObject:SetActive(true)
    self.view.scrollLoopContent:Resize(size)
end

function UIEventLayout:PlayMotion()
    if self.view.scrollLoopContent then
        self.view.scrollLoopContent:PlayMotion()
    end
end

function UIEventLayout:EnableLoopScrollContent(isEnable)
    if isEnable == false and self.view.scrollLoopContent ~= nil then
        self.view.scrollLoopContent:Hide()
    end
    self.config.VerticalScrollContent.gameObject:SetActive(isEnable)
    --self.config.scrollbar.gameObject:SetActive(isEnable)
end

--- @param eventPopupModel EventPopupModel
function UIEventLayout:OnShow(eventPopupModel)
    self:SetUpLayout()
    --assert(false)
end

function UIEventLayout:SetUpLayout()
    self:SetEventBanner()
    self:SetEventTitle()
    self:SetEventDesc()
end

function UIEventLayout:OnHide()
    --assert(false)
end

function UIEventLayout:OnDestroy()

end

function UIEventLayout:SetEventBanner()
    local eventBannerName = string.format("banner_event_%s", self.eventTimeType)
    self.config.eventBanner.sprite = ResourceLoadUtils.LoadTexture(ResourceLoadUtils.bannerEventTime, eventBannerName, ComponentName.UnityEngine_Sprite)
    self.config.eventBanner:SetNativeSize()
    self.config.eventBanner.gameObject:SetActive(true)
end

function UIEventLayout:SetEventTitle()
    self.config.eventTittle.text = EventTimeType.GetLocalize(self.eventTimeType)
end

function UIEventLayout:SetEventDesc()
    self.config.eventDesc.text = EventTimeType.GetInfoLocalize(self.eventTimeType)
end