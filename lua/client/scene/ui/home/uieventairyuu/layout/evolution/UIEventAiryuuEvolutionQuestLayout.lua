--- @class UIEventAiryuuEvolutionQuestLayout : UIEventAiryuuLayout
UIEventAiryuuEvolutionQuestLayout = Class(UIEventAiryuuEvolutionQuestLayout, UIEventAiryuuLayout)

--- @param view UIEventAiryuuView
--- @param EventAiryuuTab EventAiryuuTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventAiryuuEvolutionQuestLayout:Ctor(view, EventAiryuuTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventAiryuuEvolutionQuestLayoutConfig
    self.layoutConfig = nil
    --- @type boolean
    self.hasNoti = self:HasNoti()
    UIEventAiryuuLayout.Ctor(self, view, EventAiryuuTab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventAiryuuEvolutionQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_airyuu_evolution_quest_layout", self.anchor)
    UIEventAiryuuLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
end

function UIEventAiryuuEvolutionQuestLayout:InitLocalization()
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("airyuu_evolution_quest_title")
end

function UIEventAiryuuEvolutionQuestLayout:SetUpLayout()
    UIEventAiryuuLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventAiryuuEvolutionQuestLayout:InitButtons()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventAiryuuEvolutionQuestLayout:OnShow()
    UIEventAiryuuLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    --- @type EventAiryuuModel
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_AIRYUU)
end

function UIEventAiryuuEvolutionQuestLayout:HasNoti()
end

function UIEventAiryuuEvolutionQuestLayout:OnHide()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    UIEventAiryuuLayout.OnHide(self)
end

function UIEventAiryuuEvolutionQuestLayout:CreateQuestList()
    --- @param obj UIEventQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        if questUnitInBound.config:IsFeatureMappingAvailable() then
            obj:AddGoListener(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
        obj:AddClaimListener(function()
            self:OnClickClaim(questUnitInBound.questId,questUnitInBound.config._questType)
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventAiryuuEvolutionQuestItem, onCreateItem)
end

function UIEventAiryuuEvolutionQuestLayout:OnClickClaim(questId, type)
    local opcode = OpCode.EVENT_HERO_AIRYUU_EVOLUTION_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventAiryuuEvolutionQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestCollectionSuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventAiryuuTab.QUEST)
end

function UIEventAiryuuEvolutionQuestLayout:UpdateNotification()
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

function UIEventAiryuuEvolutionQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListCollectionQuestData()
    self.listQuestData = self.eventModel:SortQuestByData(self.listQuestData)
    self.listQuestData = QuestDataInBound.SortQuestByQuestId(self.listQuestData)
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIEventAiryuuEvolutionQuestLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventAiryuuEvolutionQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIEventAiryuu)
    end)
end