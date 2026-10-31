require "lua.client.scene.ui.home.uiEventKazetsu.eventLayout.UIEventKazetsuLayout"
--- @class UIKazetsuGiftLayout : UIEventKazetsuLayout
UIKazetsuGiftLayout = Class(UIKazetsuGiftLayout, UIEventKazetsuLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIKazetsuGiftLayout:Ctor(view, newServerWeekTab, anchor)
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIKazetsuGiftLayoutConfig
    self.layoutConfig = nil
    --- @type number
    self.tabId = EventKazetsuTab.GIFT
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    UIEventKazetsuLayout.Ctor(self, view, newServerWeekTab,anchor)
    self:InitLayoutConfig()
    self:CreateQuestList()
    --- @type boolean
    self.hasNoti = self:HasNoti()
end

--- @param objectView UnityEngine_GameObject
function UIKazetsuGiftLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("kazetsu_gift_layout", self.anchor)
    UIEventKazetsuLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIKazetsuGiftLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("event_kazetsu_gift")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("event_kazetsu_gift_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.claimAllDesc.text = LanguageUtils.LocalizeCommon("claim_all_desc")
end

function UIKazetsuGiftLayout:SetUpLayout()
    UIEventKazetsuLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIKazetsuGiftLayout:InitButtons()
    self.layoutConfig.claimAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll()
    end)
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end
    )
end

function UIKazetsuGiftLayout:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_vip_treasure"))
end


function UIKazetsuGiftLayout:InitItemShow()

end

function UIKazetsuGiftLayout:OnShow()
    UIEventKazetsuLayout.OnShow(self)
    self:GetModelConfig()
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIKazetsuGiftLayout:HasNoti()
    return self.eventModel:QuestHasNotClaimed(self.tabId)
end

function UIKazetsuGiftLayout:OnHide()
    UIEventKazetsuLayout.OnHide(self)
end


function UIKazetsuGiftLayout:CreateQuestList()
    if self.listQuestData:Count() < 1 then
        self.listQuestData = self.eventModel:GetListQuestData()
    end
    --- @param obj UIEventKazetsuQuestItem
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
            self:OnClickClaim(questUnitInBound.questId)
        end)
        obj.config.specialDeal:SetActive(questUnitInBound.config.isSpecial)
        if (questUnitInBound.config.isSpecial) then
            self.updateQuestList:Add(obj.config.textEventSpecialTime)
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventNewServerWeekQuestItem, onCreateItem)
end


function UIKazetsuGiftLayout:OnClickClaim(questId)
    ----- @type List
    --local listQuestId = List()
    --listQuestId:Add(questId)
    --print("questId :" .. questId)
    --self:RequestClaimAll(listQuestId)
    QuestDataInBound.RequestClaimQuest(OpCode.EVENT_KAZETSU_COLLECTION_QUEST_CLAIM, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

--function UIKazetsuGiftLayout:RequestClaimAll(questIds)
--    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_KAZETSU_COLLECTION_QUEST_CLAIM, questIds,
--            function(rewardList)
--                PopupUtils.ClaimAndShowRewardList(rewardList)
--                self:OnClaimQuestSuccess(questIds)
--            end)
--end


function UIKazetsuGiftLayout:OnClickClaimAll()
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


function UIKazetsuGiftLayout:OnClaimQuestSuccess(questId)
    self.view.eventModel:OnClaimQuestSuccess(questId)
    self:OnUpdateListQuest()
    --self.view:OnUpdatePurchase()
    self.view:UpdateNotificationByTab(self.tabId)
end


function UIKazetsuGiftLayout:GetDataAndUpdateView()
    --self:OnUpdateListQuest()
end

function UIKazetsuGiftLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListQuestData()
    self:FilterTabQuest()
    self.eventModel:SortQuestByData()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIKazetsuGiftLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIKazetsuGiftLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end