require "lua.client.scene.ui.home.uiEvent.community.EventCommunityPopup"

--- @class UIEventCommunityLayout : UIEventLayout
UIEventCommunityLayout = Class(UIEventCommunityLayout, UIEventLayout)

--- @param view UIEventView
function UIEventCommunityLayout:Ctor(view, eventTimeType)
    UIEventLayout.Ctor(self, view, eventTimeType)

    self:InitConfig()
end

function UIEventCommunityLayout:InitConfig()
    local inst = PrefabLoadUtils.Instantiate("popup_event_community", self.config.communityAnchor)
    --- @type EventCommunityPopup
    self.eventCommunityPopup = EventCommunityPopup(inst.transform)
end

function UIEventCommunityLayout:InitLocalization()
    self.eventCommunityPopup:InitLocalization()
end

function UIEventCommunityLayout:OnShow()
    UIEventLayout.OnShow(self)
    --self.eventCommunityPopup:OnShow()
    self.eventCommunityPopup:OnHide()
end

function UIEventCommunityLayout:SetUpLayout()
    self.config.VerticalScrollContent.gameObject:SetActive(false)
end

function UIEventCommunityLayout:OnHide()
    self.eventCommunityPopup:OnHide()
end

function UIEventCommunityLayout:PlayMotion()

end