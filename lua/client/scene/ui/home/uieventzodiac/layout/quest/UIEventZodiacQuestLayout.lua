--- @class UIEventZodiacQuestLayout : UIEventZodiacLayout
UIEventZodiacQuestLayout = Class(UIEventZodiacQuestLayout, UIEventZodiacLayout)

--- @param view UIEventZodiacView
--- @param EventZodiacTab EventZodiacTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventZodiacQuestLayout:Ctor(view, EventZodiacTab, anchor,noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventZodiacQuestConfig
    self.layoutConfig = nil
    --- @type QuestUnitInBound
    self.questCompletedUnitInbound = nil
    --- @type boolean
    self.hasNoti = self:HasNoti()
    --- @type UIEventZodiacCompletedQuestItem
    self.questCompletedItemView = nil
    UIEventZodiacLayout.Ctor(self, view, EventZodiacTab,anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventZodiacQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("zodiac_quest", self.anchor)
    UIEventZodiacLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
end

function UIEventZodiacQuestLayout:InitLocalization()
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("zodiac_quest")
end

function UIEventZodiacQuestLayout:SetUpLayout()
    UIEventZodiacLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventZodiacQuestLayout:InitButtons()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
end

function UIEventZodiacQuestLayout:OnShow()
    UIEventZodiacLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIEventZodiacQuestLayout:HasNoti()
end

function UIEventZodiacQuestLayout:OnHide()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    UIEventZodiacLayout.OnHide(self)
end


function UIEventZodiacQuestLayout:CreateQuestList()
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
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollQuestItem, UIPoolType.UIEventZodiacQuestItem, onCreateItem)

    self.questCompletedItemView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIEventZodiacCompletedQuestItem, self.uiScroll.scroll.content)
    self.questCompletedItemView:AddClaimListener(function()
        self:OnClickClaim(self.questCompletedUnitInbound.questId, self.questCompletedUnitInbound.config._questType)
    end)
end


function UIEventZodiacQuestLayout:OnClickClaim(questId,type)
    local opcode = OpCode.EVENT_ZODIAC_COLLECTION_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode , questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventZodiacQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestSuccess(questId)
    if self.questCompletedUnitInbound.questId == questId then
        self.questCompletedUnitInbound.questState = QuestState.COMPLETED
    end
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventZodiacTab.QUEST)
end

function UIEventZodiacQuestLayout:UpdateNotification()
    local noti = false
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local quest = self.listQuestData:Get(i)
        if quest.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            noti = true
        end
    end
    self.noti:SetActive(noti)
    return  noti
end


function UIEventZodiacQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListQuestData()
    self.eventModel:SortQuestByData()
    --- @param questUnitInBound QuestUnitInBound
    for i, questUnitInBound in ipairs(self.listQuestData:GetItems()) do
        if questUnitInBound.config._questType == QuestType.EVENT_COMPLETED_COLLECTION_QUEST then
            self.questCompletedUnitInbound = questUnitInBound
            self.listQuestData:RemoveByIndex(i)
        end
    end
    self:FilterTabQuest()
    self.questCompletedItemView:SetData(self.questCompletedUnitInbound.config, self.questCompletedUnitInbound)
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIEventZodiacQuestLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventZodiacQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIEventZodiac)
    end)
end