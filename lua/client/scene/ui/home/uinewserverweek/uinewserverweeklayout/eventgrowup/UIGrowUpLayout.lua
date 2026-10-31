require "lua.client.scene.ui.home.uiNewServerWeek.uiNewServerWeekLayout.UINewServerWeekLayout"
require "lua.client.scene.ui.common.UIGrowUpTreasureItemView"
--- @class UIGrowUpLayout : UINewServerWeekLayout
UIGrowUpLayout = Class(UIGrowUpLayout, UINewServerWeekLayout)

--- @param view UINewServerWeekView
--- @param newServerWeekTab NewServerWeekTab
--- @param anchor UnityEngine_RectTransform
function UIGrowUpLayout:Ctor(view, newServerWeekTab, anchor)
    --- @type UINewServerWeekView
    self.view = view
    --- @type UnityEngine_RectTransform
    self.anchor = anchor
    --- @type UIGrowUpLayoutConfig
    self.layoutConfig = nil
    --- @type number
    self.tabId = NewServerWeekTab.GROW_UP
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type List
    self.questObject = List()
    --- @type List
    self.listRewardInfo = List()
    self:InitLayoutConfig()
    self:CreateQuestList()
    --- @type boolean
    self.hasNoti = self:HasNoti()
    UINewServerWeekLayout.Ctor(self, view, newServerWeekTab,anchor)
end

--- @param objectView UnityEngine_GameObject
function UIGrowUpLayout:InitLayoutConfig(objectView)
    local inst = PrefabLoadUtils.Instantiate("new_server_grow_up_layout", self.anchor)
    UINewServerWeekLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
end

function UIGrowUpLayout:InitLocalization()
    self.layoutConfig.textGuide.text = LanguageUtils.LocalizeCommon("new_server_grow_up_guide")
    self.layoutConfig.packageTitle.text = LanguageUtils.LocalizeCommon("new_server_grow_up")
    self.layoutConfig.desc.text = LanguageUtils.LocalizeCommon("new_server_grow_up_desc")
    self.layoutConfig.claimAllText.text = LanguageUtils.LocalizeCommon("claim_all")
end

function UIGrowUpLayout:SetUpLayout()
    UINewServerWeekLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIGrowUpLayout:InitButtons()
    self.layoutConfig.claimAll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickClaimAll()
    end
    )
    self.layoutConfig.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelpInfo()
    end
    )
end

function UIGrowUpLayout:OnClickHelpInfo()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("help_grow_up"))
end

function UIGrowUpLayout:InitItemShow()

end

function UIGrowUpLayout:OnShow()
    UINewServerWeekLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
end

function UIGrowUpLayout:HasNoti()
    return self.view.eventNewServerWeekModel:QuestNewServerWeekTabHasNotClaimed(self.tabId)
end

function UIGrowUpLayout:OnHide()
    UINewServerWeekLayout.OnHide(self)
    self:HideReward()
end


function UIGrowUpLayout:CreateQuestList()
    if self.listQuestData:Count() < 1 then
        self.listQuestData = self.view.eventNewServerWeekModel:GetListQuestDataByTabId(self.tabId)
    end
    if self.listItem == nil then
        self.listItem = List()
    end
    local foundCurrentDoing = nil
    for i = 1, self.listQuestData:Count() do
        --- @type UIGrowUpTreasureItemView
        local itemOwn = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.UIGrowUpTreasureItemView,
                self.layoutConfig.line:GetChild(i - 1))

        --- @type QuestUnitInBound
        local  questUnit = self.listQuestData:Get(i)
        if questUnit.questState == QuestState.DOING then
            if foundCurrentDoing == nil then
                foundCurrentDoing = questUnit.questId
            end
        end
        questUnit.isCurrentDoing = foundCurrentDoing == questUnit.questId
        itemOwn:SetData(questUnit,function()
            self:OnClickClaim(itemOwn,i)
        end)
        self.questObject:Add(itemOwn)
    end
end


--- @param itemOwn UIGrowUpTreasureItemView
function UIGrowUpLayout:OnClickClaim(itemOwn,index)
    local questUnit = itemOwn.questUnit
    if questUnit.questState == QuestState.DONE_REWARD_NOT_CLAIM then
        --- @type List
        local listQuestId = List()
        listQuestId:Add(questUnit.questId)
        self:RequestClaimAll(listQuestId)
    else
        self:ShowReward(itemOwn.config.transform.position, index)
    end

end

function UIGrowUpLayout:RequestClaimAll(questIds)
    QuestDataInBound.RequestClaimMultiQuest(OpCode.EVENT_NEW_SERVER_OPEN_QUEST_CLAIM, questIds,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questIds)
            end)
end

function UIGrowUpLayout:OnClickClaimAll()
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


function UIGrowUpLayout:OnClaimQuestSuccess(questIds)
    for i = 1, questIds:Count() do
        self.view.eventNewServerWeekModel:OnClaimQuestSuccess(questIds:Get(i))
    end
    self:OnUpdateListQuest()
    --self.view:OnUpdatePurchase()
    self.view:UpdateNotificationByTab(self.tabId)
end


function UIGrowUpLayout:GetDataAndUpdateView()
    --self:OnUpdateListQuest()
end

function UIGrowUpLayout:OnUpdateListQuest()
    self.listQuestData = self.view.eventNewServerWeekModel:GetListQuestDataByTabId(self.tabId)
    self:FilterTabQuest()
    local foundCurrentDoing = nil
    for i = 1, self.questObject:Count() do
        local  questUnit = self.listQuestData:Get(i)
        if questUnit.questState == QuestState.DOING then
            if foundCurrentDoing == nil then
                foundCurrentDoing = questUnit.questId
            end
        end
        questUnit.isCurrentDoing = foundCurrentDoing == questUnit.questId
        self.questObject:Get(i):SetData(questUnit)
    end
end

function UIGrowUpLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIGrowUpLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end


function UIGrowUpLayout:ShowReward(position, posId)
    --if posId > 1000 then
    self:HideReward()
        --- @type QuestUnitInBound
        local  questUnit = self.listQuestData:Get(posId)
        local listReward = questUnit.config:GetListReward()
        local xSize
        ---@param v RewardInBound
        for _, v in ipairs(listReward:GetItems()) do
            --- @type RootIconView
            local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.bgListReward)
            item:SetIconData(v:GetIconData())
            item:RegisterShowInfo()
            xSize = item.iconView.config.transform.sizeDelta.x
            self.listRewardInfo:Add(item)
        end

        self.layoutConfig.bgListReward.sizeDelta = U_Vector2(xSize * listReward:Count() + 10,self.layoutConfig.bgListReward.sizeDelta.y)
        self.layoutConfig.iconSelect.position = position
        self.layoutConfig.iconSelect.gameObject:SetActive(true)
    --else
       -- self:HideReward()
    --end
end

function UIGrowUpLayout:HideReward()
    ---@param v IconView
    for _, v in pairs(self.listRewardInfo:GetItems()) do
        v:ReturnPool()
    end
    self.listRewardInfo:Clear()
    self.layoutConfig.iconSelect.gameObject:SetActive(false)
end