--- @class UIEventQixiFestivalQuestLayout : UIEventQixiFestivalLayout
UIEventQixiFestivalQuestLayout = Class(UIEventQixiFestivalQuestLayout, UIEventQixiFestivalLayout)

--- @param view UIEventQixiFestivalView
--- @param halloweenTab QixiFestivalTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventQixiFestivalQuestLayout:Ctor(view, halloweenTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventQixiFestivalQuestLayoutConfig
    self.layoutConfig = nil
    UIEventQixiFestivalLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventQixiFestivalQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("qixi_festival_quest", self.anchor)
    UIEventQixiFestivalLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIEventQixiFestivalQuestLayout:InitLocalization()
    self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("qixi_festival_quest")
    self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_qixi_festival_quest_desc")
end

function UIEventQixiFestivalQuestLayout:SetUpLayout()
    UIEventQixiFestivalLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventQixiFestivalQuestLayout:InitButtons()

end

function UIEventQixiFestivalQuestLayout:OnShow()
    UIEventQixiFestivalLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIEventQixiFestivalQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventQixiFestivalQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventQixiFestivalLayout.OnHide(self)
end

function UIEventQixiFestivalQuestLayout:CreateQuestList()
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

function UIEventQixiFestivalQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_QIXI_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventQixiFestivalQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(QixiFestivalTab.QUEST)
end

function UIEventQixiFestivalQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventQixiFestivalQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventQixiFestivalQuestLayout:InitUpdateTime()
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

function UIEventQixiFestivalQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventQixiFestivalQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventQixiFestivalQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventQixiFestivalQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end