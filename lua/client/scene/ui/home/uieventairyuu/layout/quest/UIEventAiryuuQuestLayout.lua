--- @class UIEventAiryuuQuestLayout : UIEventAiryuuLayout
UIEventAiryuuQuestLayout = Class(UIEventAiryuuQuestLayout, UIEventAiryuuLayout)

--- @param view UIEventAiryuuView
--- @param EventAiryuuTab EventAiryuuTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventAiryuuQuestLayout:Ctor(view, EventAiryuuTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventAiryuuQuestLayoutConfig
    self.layoutConfig = nil
    --- @type boolean
    self.hasNoti = self:HasNoti()
    UIEventAiryuuLayout.Ctor(self, view, EventAiryuuTab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventAiryuuQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_quest_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
end

function UIEventAiryuuQuestLayout:InitLocalization()
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_quest_title")
end

function UIEventAiryuuQuestLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventAiryuuQuestLayout:InitButtons()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventAiryuuQuestLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    --- @type EventAiryuuModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
end

function UIEventAiryuuQuestLayout:HasNoti()
end

function UIEventAiryuuQuestLayout:OnHide()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    UIEventAiryuuLayout.OnHide(self)
end

function UIEventAiryuuQuestLayout:CreateQuestList()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        obj:AddGoListener(function()
            self:OnClickGo()
        end)
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId,questUnitInBound.config._questType)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventAiryuuQuestItem, onCreateItem)
end

function UIEventAiryuuQuestLayout:OnClickClaim(questId, type)
    local opcode = OpCode.EVENT_HERO_AIRYUU_TREASURE_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventAiryuuQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestTreasureSuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventAiryuuTab.QUEST)
end

function UIEventAiryuuQuestLayout:UpdateNotification()
    local noti = false
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local quest = self.listQuestData:Get(i)
        if quest.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            noti = true
        end
    end
    self.noti:SetActive(noti)
    return noti
end

function UIEventAiryuuQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListTreasureQuestData()
    self.listQuestData = QuestDataInBound.SortQuestByQuestId(self.listQuestData)
    self.listQuestData = self.eventModel:SortQuestByData(self.listQuestData)
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIEventAiryuuQuestLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventAiryuuQuestLayout:OnClickGo()
    self:OnHide()
    self.view:SelectTab(EventAiryuuTab.HERO_TREASURE)
end