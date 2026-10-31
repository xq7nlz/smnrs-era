--- @class UIEventNewYear2023QuestLayout : UIEventNewYear2023Layout
UIEventNewYear2023QuestLayout = Class(UIEventNewYear2023QuestLayout, UIEventNewYear2023Layout)

--- @param view UIEventNewYear2023View
--- @param halloweenTab NewYear2023Tab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventNewYear2023QuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventNewYear2023QuestLayoutConfig
    self.layoutConfig = nil
    UIEventNewYear2023Layout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventNewYear2023QuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_2023_quest", self.anchor)
    UIEventNewYear2023Layout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventNewYear2023QuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("new_year_2023_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_new_year_2023_quest_desc")
end

function UIEventNewYear2023QuestLayout:SetUpLayout()
    UIEventNewYear2023Layout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventNewYear2023QuestLayout:InitButtons()

end

function UIEventNewYear2023QuestLayout:OnShow()
    UIEventNewYear2023Layout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventNewYear2023QuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventNewYear2023QuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventNewYear2023Layout.OnHide(self)
end

function UIEventNewYear2023QuestLayout:CreateQuestList()
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

function UIEventNewYear2023QuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_NEW_YEAR_2023_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventNewYear2023QuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(NewYear2023Tab.QUEST)
end

function UIEventNewYear2023QuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventNewYear2023QuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventNewYear2023QuestLayout:InitUpdateTime()
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

function UIEventNewYear2023QuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventNewYear2023QuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventNewYear2023QuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventNewYear2023QuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end