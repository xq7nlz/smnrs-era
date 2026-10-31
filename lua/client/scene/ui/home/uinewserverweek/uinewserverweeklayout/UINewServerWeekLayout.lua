--- @class UINewServerWeekLayout : UIEventLayout
UINewServerWeekLayout = Class(UINewServerWeekLayout)

--- @param view UIEventHalloweenView
--- @param newServerWeek NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UINewServerWeekLayout:Ctor(view, newServerWeek, anchor)
    --- @type UINewServerWeekView
    self.view = view
    --- @type NewServerWeekTab
    self.newServerWeekTabId = newServerWeek
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type EventNewServerWeekModel
    self.newServerWeekModel = nil
    --- @type UINewServerConfig
    self.eventConfig = nil
    --self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UINewServerWeekLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
end

function UINewServerWeekLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UINewServerWeekLayout:SetEventBanner()
end

function UINewServerWeekLayout:SetEventTitle()
end

function UINewServerWeekLayout:SetEventDesc()
end

function UINewServerWeekLayout:InitButtons()
end

function UINewServerWeekLayout:GetDataAndUpdateView()
end

function UINewServerWeekLayout:OnShow()
    self:GetModelConfig()
    self.anchor.gameObject:SetActive(true)
end

function UINewServerWeekLayout:OnHide()
end


function UINewServerWeekLayout:HasNoti()
end

function UINewServerWeekLayout:GetModelConfig()
    self.newServerWeekModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK)
    if self.newServerWeekModel ~= nil then
        self.eventConfig = self.newServerWeekModel:GetConfig()
    end
    self.newServerWeek2Model = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_2)
    if self.newServerWeek2Model ~= nil then
        self.eventConfig2 = self.newServerWeek2Model:GetConfig()
    end
    self.newServerWeek3Model = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_NEW_SERVER_WEEK_3)
    if self.newServerWeek3Model ~= nil then
        self.eventConfig3 = self.newServerWeek3Model:GetConfig()
    end
end

