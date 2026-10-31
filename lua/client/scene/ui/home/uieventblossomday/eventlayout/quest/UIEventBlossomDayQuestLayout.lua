--- @class UIEventBlossomDayQuestLayout : UIEventBlossomDayLayout
UIEventBlossomDayQuestLayout = Class(UIEventBlossomDayQuestLayout, UIEventBlossomDayLayout)

--- @param view UIEventNewYear2023View
--- @param halloweenTab NewYear2023Tab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventBlossomDayQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventBlossomDayQuestLayoutConfig
    self.layoutConfig = nil
    UIEventBlossomDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventBlossomDayQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("blossom_day_quest", self.anchor)
    UIEventBlossomDayLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventBlossomDayQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("blossom_day_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_blossom_day_quest_desc")
end

function UIEventBlossomDayQuestLayout:SetUpLayout()
    UIEventBlossomDayLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventBlossomDayQuestLayout:InitButtons()

end

function UIEventBlossomDayQuestLayout:OnShow()
    UIEventBlossomDayLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventBlossomDayQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventBlossomDayQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventBlossomDayLayout.OnHide(self)
end

function UIEventBlossomDayQuestLayout:CreateQuestList()
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

function UIEventBlossomDayQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_BLOSSOM_DAY_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventBlossomDayQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(BlossomDayTab.QUEST)
end

function UIEventBlossomDayQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventBlossomDayQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventBlossomDayQuestLayout:InitUpdateTime()
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

function UIEventBlossomDayQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventBlossomDayQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventBlossomDayQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventBlossomDayQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end