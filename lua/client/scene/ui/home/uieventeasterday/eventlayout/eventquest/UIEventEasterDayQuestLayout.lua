--- @class UIEventEasterDayQuestLayout : UIEventEasterDayLayout
UIEventEasterDayQuestLayout = Class(UIEventEasterDayQuestLayout, UIEventEasterDayLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventEasterDayQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventEasterDayQuestLayoutConfig
    self.layoutConfig = nil
    UIEventEasterDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventEasterDayQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_day_quest", self.anchor)
    UIEventEasterDayLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventEasterDayQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("easter_day_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_easter_day_quest_desc")
end

function UIEventEasterDayQuestLayout:SetUpLayout()
    UIEventEasterDayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventEasterDayQuestLayout:InitButtons()

end

function UIEventEasterDayQuestLayout:OnShow()
    UIEventEasterDayLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventEasterDayQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventEasterDayQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventEasterDayLayout.OnHide(self)
end

function UIEventEasterDayQuestLayout:CreateQuestList()
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

function UIEventEasterDayQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_EASTERS_EGG_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventEasterDayQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EasterDayTab.QUEST)
end

function UIEventEasterDayQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventEasterDayQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventEasterDayQuestLayout:InitUpdateTime()
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

function UIEventEasterDayQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventEasterDayQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventEasterDayQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventEasterDayQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end