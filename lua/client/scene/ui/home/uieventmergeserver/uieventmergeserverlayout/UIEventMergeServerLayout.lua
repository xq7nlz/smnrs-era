--- @class UIEventMergeServerLayout : UIEventLayout
UIEventMergeServerLayout = Class(UIEventMergeServerLayout, UIEventLayout)

--- @param view UIEventMergeServerView
--- @param mergeServerTab MergeServerTab
--- @param anchor UnityEngine_RectTransform
function UIEventMergeServerLayout:Ctor(view, mergeServerTab, anchor)
    --- @type UIEventMergeServerView
    self.view = view
    --- @type MergeServerTab
    self.mergeServerTab = mergeServerTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventMergeServerModel
    self.eventModel = nil
    --- @type EventMergeServerConfig
    self.eventConfig = nil
    self.eventTimeType = EventTimeType.EVENT_MERGE_SERVER
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventMergeServerLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UIEventMergeServerLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventMergeServerLayout:SetEventBanner()
end

function UIEventMergeServerLayout:SetEventTitle()
end

function UIEventMergeServerLayout:SetEventDesc()
end

function UIEventMergeServerLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventMergeServerLayout:OnHide()
    UIEventLayout.OnHide(self)
    self.anchor.gameObject:SetActive(false)
end

function UIEventMergeServerLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end




