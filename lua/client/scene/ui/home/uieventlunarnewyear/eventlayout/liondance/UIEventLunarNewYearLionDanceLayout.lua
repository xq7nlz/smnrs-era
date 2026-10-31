require "lua.client.scene.ui.home.uiEventLunarNewYear.eventLayout.UIEventLunarNewYearLayout"
require "lua.client.scene.ui.home.uiEventMidAutumn.uiEventMidAutumnLayout.feedTheBeast.BeastAutumn"
--- @class UIEventLunarNewYearLionDanceLayout : UIEventLunarNewYearLayout
UIEventLunarNewYearLionDanceLayout = Class(UIEventLunarNewYearLionDanceLayout, UIEventLunarNewYearLayout)

--- @param view UINewServerWeekView
--- @param lunarNewYearTab LunarNewYearTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarNewYearLionDanceLayout:Ctor(view, lunarNewYearTab, anchor)
    --- @type UIEventLunarNewYearView
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type LunarNewYearLionDanceLayoutConfig
    self.layoutConfig = nil
    --- @type number
    self.tabId = LunarNewYearTab.LION_DANCE
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    UIEventLunarNewYearLayout.Ctor(self, view, lunarNewYearTab, anchor)
    --- @type BeastAutumn
    self.beastAutumn = nil
    --- @type Dictionary
    self.beastAutumnDict = Dictionary()
    --- @type List
    self.listItem = List()
end

--- @param objectView UnityEngine_GameObject
function UIEventLunarNewYearLionDanceLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("lunar_new_year_lion_dance", self.anchor)
    UIEventLunarNewYearLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:InitRewardList()
end

function UIEventLunarNewYearLionDanceLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_lion_dance")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("event_lunar_new_year_lion_dance_decs")
    self.layoutConfig.claimAllDesc.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
end

function UIEventLunarNewYearLionDanceLayout:SetUpLayout()
    UIEventLunarNewYearLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventLunarNewYearLionDanceLayout:InitButtons()
    self.layoutConfig.claimAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll()
    end)
end

function UIEventLunarNewYearLionDanceLayout:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_vip_treasure"))
end

function UIEventLunarNewYearLionDanceLayout:InitItemShow()

end

function UIEventLunarNewYearLionDanceLayout:OnShow()
    UIEventLunarNewYearLayout.OnShow(self)
    self.listQuestData = self.eventModel:GetListQuestData()
    self:InitLocalization()
    self:ShowBeastModel()
    self:HasNoti()
    self:FillQuestProgress()
    self:OnUpdateListQuest()
end

function UIEventLunarNewYearLionDanceLayout:FillQuestProgress()
    local questUnitInBound = self:GetCurrentQuest()
    local currentPoint = InventoryUtils.GetMoney(MoneyType.EVENT_LUNAR_2022_LUCKY_COIN)
    local target = questUnitInBound.config:GetMainRequirementTarget()
    if currentPoint > target then
        questUnitInBound = self:GetCurrentQuestUpdated()
        self:UpdateQuestState()
    end
    target = questUnitInBound.config:GetMainRequirementTarget() or target
    self.layoutConfig.textLevel.text = "Lv." .. tostring(questUnitInBound.questId)
    self.layoutConfig.textProgressExp.text = currentPoint .. "/" .. target
    self.layoutConfig.progressBar.fillAmount = currentPoint / target
end

function UIEventLunarNewYearLionDanceLayout:GetCurrentQuest()
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(i)
        if questUnitInBound.questState == QuestState.DOING then
            return questUnitInBound
        end
    end
    return self.listQuestData:Get(self.listQuestData:Count())
end

function UIEventLunarNewYearLionDanceLayout:GetCurrentQuestUpdated()
    local currentPoint = InventoryUtils.GetMoney(MoneyType.EVENT_LUNAR_2022_LUCKY_COIN)
    for _, v in pairs(self.listQuestData:GetItems()) do
        local targetPoint = v.config:GetMainRequirementTarget()
        if targetPoint > currentPoint then
            return v
        end
    end
end

function UIEventLunarNewYearLionDanceLayout:UpdateQuestState()
    --local questIdNotUpdated = self:GetCurrentQuest().questId
    local questIdUpdated = self:GetCurrentQuestUpdated().questId
    --for i = questIdNotUpdated, questIdUpdated - 1 do
    --for i = 1, questIdUpdated - 1 do
    --    if self.listQuestData:Get(i).questState == QuestState.DOING then
    --        self.listQuestData:Get(i).questState = QuestState.DONE_REWARD_NOT_CLAIM
    --    end
    --end
    self.eventModel:UpdateListQuestData(questIdUpdated)
    self.listQuestData = self.eventModel.listQuestData
end

function UIEventLunarNewYearLionDanceLayout:HasNoti()
    self.eventModel = zg.playerData:GetEvents():GetEvent(self.eventTimeType)
    local tabNoti = self.eventModel:QuestLionDanceHasNotClaimed()
    self.layoutConfig.notification.gameObject:SetActive(tabNoti)
    local itemNoti = false
    for i = 1, self.listItem:Count() do
        if self.listItem:Get(i):ItemHasNoti() then
            itemNoti = true
        end
    end
    return tabNoti or itemNoti
end

function UIEventLunarNewYearLionDanceLayout:OnHide()
    UIEventLunarNewYearLayout.OnHide(self)
    self.uiScroll:Hide()
end

function UIEventLunarNewYearLionDanceLayout:InitRewardList()
    if self.listQuestData:Count() == 0 then
        self.listQuestData = self.eventModel:GetListQuestData()
    end
    --- @param obj LionDanceLevelRewardItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        --obj:AddClaimListener(function()
        --    self:OnClickClaim(questUnitInBound.questId)
        --end)
        self.listItem:Add(obj)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.LionDanceLevelRewardItem, onCreateItem)
end

function UIEventLunarNewYearLionDanceLayout:OnClickClaim(questId)
    --- @type List
    local listQuestId = List()
    listQuestId:Add(questId)
    self:RequestClaimAll(listQuestId)
end

function UIEventLunarNewYearLionDanceLayout:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_LUNAR_2022_LION_DANCE_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
                self.layoutConfig.notification.gameObject:SetActive(false)
            end)
end

function UIEventLunarNewYearLionDanceLayout:OnClickClaimAll()
    --- @type List
    local listQuestId = List()
    local haveNotDoneQuest = false
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local questInbound = self.listQuestData:Get(i)
        if questInbound.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            listQuestId:Add(questInbound.questId)
        elseif questInbound.questState == QuestState.DOING then
            haveNotDoneQuest = true
        end
    end
    if listQuestId:Count() < 1 then
        local content = "all_received"
        if haveNotDoneQuest then
            content = "have_no_done_quest_to_claim"
        end
        SmartPoolUtils.ShowShortNotification(
                LanguageUtils.LocalizeCommon(content))
        return
    end
    self:RequestClaimAll(listQuestId)
end

function UIEventLunarNewYearLionDanceLayout:OnClaimQuestSuccess(questIds)
    for i = 1, questIds:Count() do
        self.eventModel:OnClaimQuestSuccess(questIds:Get(i))
    end
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(LunarNewYearTab.LION_DANCE)
end

function UIEventLunarNewYearLionDanceLayout:GetDataAndUpdateView()
    --self:OnUpdateListQuest()
end

function UIEventLunarNewYearLionDanceLayout:OnUpdateListQuest()
    self:FilterTabQuest()
    self:HasNoti()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIEventLunarNewYearLionDanceLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventLunarNewYearLionDanceLayout:ShowBeastModel()
    --self.layoutConfig.beast.AnimationState:SetAnimation(0, "idle", true)
    --self.beastAutumn = BeastAutumn(self.layoutConfig.beast,4)
    --self.beastAutumn:PlayIdle()
end

function UIEventLunarNewYearLionDanceLayout:HideBeast()
    if self.beastAutumn ~= nil then
        self.beastAutumn:SetActive(false)
        self.beastAutumn = nil
    end
end