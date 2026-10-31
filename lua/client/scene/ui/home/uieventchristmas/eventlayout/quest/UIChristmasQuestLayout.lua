--- @class UIChristmasQuestLayout : UIEventChristmasLayout
UIChristmasQuestLayout = Class(UIChristmasQuestLayout, UIEventChristmasLayout)

--- @param view UIEventChristmasView
--- @param tab ChristmasTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIChristmasQuestLayout:Ctor(view, tab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuest = List()
    --- @type UIEventChristmasQuestLayoutConfig
    self.layoutConfig = nil
    UIEventChristmasLayout.Ctor(self, view, tab, anchor)
end

function UIChristmasQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_christmas_quest_layout", self.anchor)
    UIEventChristmasLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()

end

function UIChristmasQuestLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("event_christmas_quest_title")
    self.layoutConfig.eventContent.text = LanguageUtils.LocalizeCommon("event_christmas_quest_content")
end

function UIChristmasQuestLayout:SetUpLayout()
    UIEventChristmasLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIChristmasQuestLayout:InitButtons()

end

function UIChristmasQuestLayout:GetModelConfig()
    UIEventChristmasLayout.GetModelConfig(self)
    self.listQuest = self.eventMidAutumnModel
end

function UIChristmasQuestLayout:OnShow()
    UIEventChristmasLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:StartUpdateTime()
end

function UIChristmasQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIChristmasQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:RemoveUpdateTime()
    UIEventChristmasLayout.OnHide(self)
end

function UIChristmasQuestLayout:CreateQuestList()
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

function UIChristmasQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_CHRISTMAS_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIChristmasQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(ChristmasTab.QUEST)
end

function UIChristmasQuestLayout:OnUpdateListQuest()
    self.listQuest = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuest:Count()
    self.uiScroll:Resize(count)
end

function UIChristmasQuestLayout:OnClickGo(questId, questElementConfig)
    if questElementConfig._questType == 2901 then
        self:OnHide()
        self.view:SelectTab(ChristmasTab.FEED_BEAST)
    elseif questElementConfig._questType == 2001 and questElementConfig:GetRequirementsByIndex(2) == 180 then
        self:OnHide()
        self.view:SelectTab(ChristmasTab.ARENA)
    else
        QuestDataInBound.GoQuest(questId, questElementConfig, function()
            PopupMgr.HidePopup(self.view.model.uiName)
        end)
    end
end

function UIChristmasQuestLayout:InitUpdateTime()
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

function UIChristmasQuestLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIChristmasQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIChristmasQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIChristmasQuestLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end