require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
--- @class UIVipTreasureLayout : UINewServerWeekLayout
UIVipTreasureLayout = Class(UIVipTreasureLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIVipTreasureLayout:Ctor(view, newServerWeekTab, anchor)
    --- @type UINewServerWeekView
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIVipTreasureLayoutConfig
    self.layoutConfig = nil
    --- @type number
    self.tabId = NewServerWeekTab.VIP_TREASURE
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    UINewServerWeekLayout.Ctor(self, view, newServerWeekTab,anchor)
    self:InitLayoutConfig()
    self:CreateQuestList()
    --- @type boolean
    self.hasNoti = self:HasNoti()
end

--- @param objectView UnityEngine_GameObject
function UIVipTreasureLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_vip_treasure_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIVipTreasureLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_vip_treasure")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_vip_treasure_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.claimAllDesc.text = LanguageUtils.LocalizeCommon("claim_all_desc")
end

function UIVipTreasureLayout:SetUpLayout()
    UINewServerWeekLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIVipTreasureLayout:InitButtons()
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

function UIVipTreasureLayout:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_vip_treasure"))
end


function UIVipTreasureLayout:InitItemShow()

end

function UIVipTreasureLayout:OnShow()
    UINewServerWeekLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIVipTreasureLayout:HasNoti()
    return self.view.eventNewServerWeekModel:QuestNewServerWeekTabHasNotClaimed(self.tabId)
end

function UIVipTreasureLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
end


function UIVipTreasureLayout:CreateQuestList()
    if self.listQuestData:Count() < 1 then
        self.listQuestData = self.view.eventNewServerWeekModel:GetListQuestDataByTabId(self.tabId)
    end
    --- @param obj UIEventNewServerWeekQuestItem
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


function UIVipTreasureLayout:OnClickClaim(questId)
    --- @type List
    local listQuestId = List()
    listQuestId:Add(questId)
    self:RequestClaimAll(listQuestId)
end

function UIVipTreasureLayout:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end


function UIVipTreasureLayout:OnClickClaimAll()
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


function UIVipTreasureLayout:OnClaimQuestSuccess(questIds)
    for i = 1, questIds:Count() do
        self.view.eventNewServerWeekModel:OnClaimQuestSuccess(questIds:Get(i))
    end
    self:OnUpdateListQuest()
    --self.view:OnUpdatePurchase()
    self.view:UpdateNotificationByTab(self.tabId)
end


function UIVipTreasureLayout:GetDataAndUpdateView()
    --self:OnUpdateListQuest()
end

function UIVipTreasureLayout:OnUpdateListQuest()
    self.listQuestData = self.view.eventNewServerWeekModel:GetListQuestDataByTabId(self.tabId)
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIVipTreasureLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIVipTreasureLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end