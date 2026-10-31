--- @class UIEventHalloweenQuestLayout : UIEventHalloweenLayout
UIEventHalloweenQuestLayout = Class(UIEventHalloweenQuestLayout, UIEventHalloweenLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventHalloweenQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventHalloweenQuestLayoutConfig
    self.layoutConfig = nil
    UIEventHalloweenLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventHalloweenQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("halloween_quest", self.anchor)
    UIEventHalloweenLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventHalloweenQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_halloween_quest_title")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_halloween_quest_desc")
end

function UIEventHalloweenQuestLayout:SetUpLayout()
    UIEventHalloweenLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventHalloweenQuestLayout:InitButtons()

end

function UIEventHalloweenQuestLayout:OnShow()
    UIEventHalloweenLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventHalloweenQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventHalloweenQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventHalloweenLayout.OnHide(self)
end

function UIEventHalloweenQuestLayout:CreateQuestList()
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

function UIEventHalloweenQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_HALLOWEEN_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventHalloweenQuestLayout:OnClaimQuestSuccess(questId)
    self.eventHalloweenModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(HalloweenTab.QUEST)
end

function UIEventHalloweenQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventHalloweenModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventHalloweenQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventHalloweenQuestLayout:InitUpdateTime()
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

function UIEventHalloweenQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventHalloweenQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventHalloweenQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventHalloweenQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end