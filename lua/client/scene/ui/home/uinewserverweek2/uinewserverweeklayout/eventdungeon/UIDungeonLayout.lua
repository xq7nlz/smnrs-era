require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
--- @class UIDungeonLayout : UINewServerWeekLayout
UIDungeonLayout = Class(UIDungeonLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView2
--- @param newServerWeekTab NewServerWeekTab2
--- @param anchor UnityEngine_RectTransform
function UIDungeonLayout:Ctor(view, newServerWeekTab, anchor)
    --- @type UINewServerWeekView2
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIVipTreasureLayoutConfig
    self.layoutConfig = nil
    --- @type number
    self.tabId = NewServerWeekTab2.DUNGEON
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
function UIDungeonLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_dungeon_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIDungeonLayout:InitLocalization()
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_dungeon")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_dungeon_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
    self.layoutConfig.claimAllDesc.text = LanguageUtils.LocalizeCommon("claim_all_desc")
end

function UIDungeonLayout:SetUpLayout()
    UINewServerWeekLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIDungeonLayout:InitButtons()
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

function UIDungeonLayout:OnClickHelpInfo()
end


function UIDungeonLayout:InitItemShow()

end

function UIDungeonLayout:OnShow()
    UINewServerWeekLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIDungeonLayout:HasNoti()
    return self.view.eventNewServerWeekModel:QuestNewServerWeekTabHasNotClaimed(self.tabId)
end

function UIDungeonLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
end


function UIDungeonLayout:CreateQuestList()
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


function UIDungeonLayout:OnClickClaim(questId)
    --- @type List
    local listQuestId = List()
    listQuestId:Add(questId)
    self:RequestClaimAll(listQuestId)
end

function UIDungeonLayout:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_2_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end


function UIDungeonLayout:OnClickClaimAll()
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


function UIDungeonLayout:OnClaimQuestSuccess(questIds)
    for i = 1, questIds:Count() do
        self.view.eventNewServerWeekModel:OnClaimQuestSuccess(questIds:Get(i))
    end
    self:OnUpdateListQuest()
    --self.view:OnUpdatePurchase()
    self.view:UpdateNotificationByTab(self.tabId)
end


function UIDungeonLayout:GetDataAndUpdateView()
    --self:OnUpdateListQuest()
end

function UIDungeonLayout:OnUpdateListQuest()
    self.listQuestData = self.view.eventNewServerWeekModel:GetListQuestDataByTabId(self.tabId)
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIDungeonLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIDungeonLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end