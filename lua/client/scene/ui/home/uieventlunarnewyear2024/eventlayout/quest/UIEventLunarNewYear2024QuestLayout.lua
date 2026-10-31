--- @class UIEventLunarNewYear2024QuestLayout : UIEventLunarNewYear2024Layout
UIEventLunarNewYear2024QuestLayout = Class(UIEventLunarNewYear2024QuestLayout, UIEventLunarNewYear2024Layout)

--- @param view UIEventLunarNewYear2024View
--- @param halloweenTab LunarNewYear2024Tab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventLunarNewYear2024QuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventLunarNewYear2024QuestLayoutConfig
    self.layoutConfig = nil
    UIEventLunarNewYear2024Layout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventLunarNewYear2024QuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_2024_quest", self.anchor)
    UIEventLunarNewYear2024Layout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventLunarNewYear2024QuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("lunar_new_year_2024_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_2024_quest_desc")
end

function UIEventLunarNewYear2024QuestLayout:SetUpLayout()
    UIEventLunarNewYear2024Layout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarNewYear2024QuestLayout:InitButtons()

end

function UIEventLunarNewYear2024QuestLayout:OnShow()
    UIEventLunarNewYear2024Layout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventLunarNewYear2024QuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventLunarNewYear2024QuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventLunarNewYear2024Layout.OnHide(self)
end

function UIEventLunarNewYear2024QuestLayout:CreateQuestList()
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

function UIEventLunarNewYear2024QuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_LUNAR_NEW_YEAR_2024_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventLunarNewYear2024QuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(LunarNewYear2024Tab.QUEST)
end

function UIEventLunarNewYear2024QuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventLunarNewYear2024QuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventLunarNewYear2024QuestLayout:InitUpdateTime()
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

function UIEventLunarNewYear2024QuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventLunarNewYear2024QuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventLunarNewYear2024QuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventLunarNewYear2024QuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end