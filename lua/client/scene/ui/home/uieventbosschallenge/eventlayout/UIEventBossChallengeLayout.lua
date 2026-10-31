require "lua.client.scene.ui.common.UIBarPercentView"

--- @class UIEventBossChallengeLayout : UIEventLayout
UIEventBossChallengeLayout = Class(UIEventBossChallengeLayout, UIEventLayout)

--- @param view UIEventBossChallengeView
--- @param eventBossChallengeTab EventBossChallengeTab
--- @param anchor UnityEngine_RectTransform
function UIEventBossChallengeLayout:Ctor(view, eventBossChallengeTab, anchor)
    --- @type UIEventBossChallengeView
    self.view = view
    --- @type EventBossChallengeTab
    self.eventBossChallengeTab = eventBossChallengeTab
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIBaseConfig
    self.layoutConfig = nil
    --- @type EventBossChallengeModel
    self.eventModel = nil
    --- @type EventBossChallengeConfig
    self.eventConfig = nil
    ---@type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_BOSS_CHALLENGE
    UIEventLayout.Ctor(self, view, self.eventTimeType)
    self:InitLayoutConfig()
end

--- @param objectView UnityEngine_GameObject
function UIEventBossChallengeLayout:InitLayoutConfig(objectView)
    self.layoutConfig = UIBaseConfig(objectView.transform)
    UIUtils.SetParent(objectView.transform, self.anchor)
    objectView:SetActive(true)
    self:GetModelConfig()
end

function UIEventBossChallengeLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBossChallengeLayout:SetEventBanner()
end

function UIEventBossChallengeLayout:SetEventTitle()
end

function UIEventBossChallengeLayout:SetEventDesc()
end

function UIEventBossChallengeLayout:OnShow()
    self:GetModelConfig()
    UIEventLayout.OnShow(self)
end

function UIEventBossChallengeLayout:CloseLayout()
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_CLOSE)
    self:OnHide()
end

function UIEventBossChallengeLayout:OnHide()
    UIEventLayout.OnHide(self)
    EventInBound.ValidateEventModel(function()
        self.view.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
        self.view:CheckAllNotificationTab()
    end, true)
    self.view.layout = nil
    self.anchor.gameObject:SetActive(false)
end

function UIEventBossChallengeLayout:GetModelConfig()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    if self.eventModel ~= nil then
        self.eventConfig = self.eventModel:GetConfig()
    end
end

function UIEventBossChallengeLayout:SetNextDayTime()
    self.onEventTimeEnded = self:OnEventTimeEnded()
    self:StartUpdateTime()
end

function UIEventBossChallengeLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventBossChallengeLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventBossChallengeLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventBossChallengeLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventBossChallengeLayout:InitUpdateTime()
    print("need override")
end




