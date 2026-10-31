--- @class UIEventMayDayQuestLayout : UIEventMayDayLayout
UIEventMayDayQuestLayout = Class(UIEventMayDayQuestLayout, UIEventMayDayLayout)

--- @param view UIEventMayDayView
--- @param halloweenTab MayDayTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventMayDayQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventMayDayQuestLayoutConfig
    self.layoutConfig = nil
    UIEventMayDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventMayDayQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("may_day_quest", self.anchor)
    UIEventMayDayLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventMayDayQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("may_day_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_may_day_quest_desc")
end

function UIEventMayDayQuestLayout:SetUpLayout()
    UIEventMayDayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventMayDayQuestLayout:InitButtons()

end

function UIEventMayDayQuestLayout:OnShow()
    UIEventMayDayLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventMayDayQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventMayDayQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventMayDayLayout.OnHide(self)
end

function UIEventMayDayQuestLayout:CreateQuestList()
    --- @param obj UIEventHalloweenQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        if questUnitInBound.config:IsFeatureMappingAvailable() then
            obj:SetButtonGotoData(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollVertical, UIPoolType.UIEventHalloweenQuestItem, onCreateItem)
end

function UIEventMayDayQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_MAY_DAY_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventMayDayQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(MayDayTab.QUEST)
end

function UIEventMayDayQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventMayDayQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventMayDayQuestLayout:InitUpdateTime()
    self.layoutConfig.time.gameObject:SetActive(true)
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.time.text = string.format(LanguageUtils.LocalizeCommon("refresh_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end

function UIEventMayDayQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventMayDayQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventMayDayQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventMayDayQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end