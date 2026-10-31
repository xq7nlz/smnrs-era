--- @class UIMidAutumnQuestLayout : UIEventMidAutumnLayout
UIMidAutumnQuestLayout = Class(UIMidAutumnQuestLayout, UIEventMidAutumnLayout)

--- @param view UIEventMidAutumnView
--- @param eventMidAutumnTab MidAutumnTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIMidAutumnQuestLayout:Ctor(view, eventMidAutumnTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuest = List()
    --- @type UIEventMidAutumnQuestLayoutConfig
    self.layoutConfig = nil
    UIEventMidAutumnLayout.Ctor(self, view, eventMidAutumnTab, anchor)
end

function UIMidAutumnQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_mid_autumn_quest_layout", self.anchor)
    UIEventMidAutumnLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIMidAutumnQuestLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("event_mid_autumn_quest_title")
    self.layoutConfig.eventContent.text = LanguageUtils.LocalizeCommon("event_mid_autumn_quest_content")
end

function UIMidAutumnQuestLayout:SetUpLayout()
    UIEventMidAutumnLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIMidAutumnQuestLayout:InitButtons()

end

function UIMidAutumnQuestLayout:GetModelConfig()
    UIEventMidAutumnLayout.GetModelConfig(self)
    self.listQuest = self.eventMidAutumnModel
end

function UIMidAutumnQuestLayout:OnShow()
    UIEventMidAutumnLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIMidAutumnQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIMidAutumnQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventMidAutumnLayout.OnHide(self)
end

function UIMidAutumnQuestLayout:CreateQuestList()
    --- @param obj UIEventMidAutumnQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuest:Get(dataIndex)
        obj:SetData(questUnitInBound)
        if questUnitInBound.config:IsFeatureMappingAvailable() or questUnitInBound ~= nil then
            obj:SetButtonGotoData(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventMidAutumnQuestItem, onCreateItem)
end

function UIMidAutumnQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_MID_AUTUMN_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIMidAutumnQuestLayout:OnClaimQuestSuccess(questId)
    self.eventMidAutumnModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(MidAutumnTab.QUEST)
end

function UIMidAutumnQuestLayout:OnUpdateListQuest()
    self.listQuest = self.eventMidAutumnModel:GetListSortedDailyQuestData()
    local count = self.listQuest:Count()
    self.uiScroll:Resize(count)
end

function UIMidAutumnQuestLayout:OnClickGo(questId, questElementConfig)
    if questElementConfig._questType == 2901 then
        self:OnHide()
        self.view:SelectTab(MidAutumnTab.FEED_BEAST)
    elseif questElementConfig._questType == 2001 and questElementConfig:GetRequirementsByIndex(2) == 180 then
        self:OnHide()
        self.view:SelectTab(MidAutumnTab.ARENA)
    else
        QuestDataInBound.GoQuest(questId, questElementConfig, function()
            PopupMgr.HidePopup(self.view.model.uiName)
        end)
    end
end

function UIMidAutumnQuestLayout:InitUpdateTime()
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

function UIMidAutumnQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIMidAutumnQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIMidAutumnQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIMidAutumnQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end