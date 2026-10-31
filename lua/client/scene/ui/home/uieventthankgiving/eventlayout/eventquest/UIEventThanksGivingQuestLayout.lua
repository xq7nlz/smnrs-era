--- @class UIEventThanksGivingQuestLayout : UIEventThanksGivingLayout
UIEventThanksGivingQuestLayout = Class(UIEventThanksGivingQuestLayout, UIEventThanksGivingLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventThanksGivingQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventThanksGivingQuestLayoutConfig
    self.layoutConfig = nil
    UIEventThanksGivingLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventThanksGivingQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("thanks_giving_quest", self.anchor)
    UIEventThanksGivingLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventThanksGivingQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_thanks_giving_quest_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_thanks_giving_quest_desc")
end

function UIEventThanksGivingQuestLayout:SetUpLayout()
    UIEventThanksGivingLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventThanksGivingQuestLayout:InitButtons()

end

function UIEventThanksGivingQuestLayout:OnShow()
    UIEventThanksGivingLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventThanksGivingQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventThanksGivingQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventThanksGivingLayout.OnHide(self)
end

function UIEventThanksGivingQuestLayout:CreateQuestList()
    --- @param obj UIEventBossChallengeQuestItem
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

function UIEventThanksGivingQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_THANKS_GIVING_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventThanksGivingQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(ThankGivingTab.QUEST)
end

function UIEventThanksGivingQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventThanksGivingQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventThanksGivingQuestLayout:InitUpdateTime()
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

function UIEventThanksGivingQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventThanksGivingQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventThanksGivingQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventThanksGivingQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end