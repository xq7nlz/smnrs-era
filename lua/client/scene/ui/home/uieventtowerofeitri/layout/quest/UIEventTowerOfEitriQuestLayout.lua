--- @class UIEventTowerOfEitriQuestLayout : UIEventTowerOfEitriLayout
UIEventTowerOfEitriQuestLayout = Class(UIEventTowerOfEitriQuestLayout, UIEventTowerOfEitriLayout)

--- @param view UIEventTowerOfEitri
--- @param eventTowerOfEitriTab EventTowerOfEitriTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventTowerOfEitriQuestLayout:Ctor(view, eventTowerOfEitriTab, anchor, noti)
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type UIEventTowerOfEitriQuestLayoutConfig
    self.layoutConfig = nil
    UIEventTowerOfEitriLayout.Ctor(self, view, eventTowerOfEitriTab, anchor)
end

function UIEventTowerOfEitriQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_tower_of_eitri_quest_layout", self.anchor)
    UIEventTowerOfEitriLayout.InitLayoutConfig(self, inst)
    self:InitButtons()
    self:InitLocalization()
    self:CreateQuestList()
    self:InitUpdateTime()
end

function UIEventTowerOfEitriQuestLayout:InitLocalization()
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("tower_of_eitri_quest_title")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("tower_of_eitri_quest_infor")
end

function UIEventTowerOfEitriQuestLayout:SetUpLayout()
    UIEventTowerOfEitriLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventTowerOfEitriQuestLayout:InitButtons()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_tower_of_eitri_quest_info"))
    end)
end

function UIEventTowerOfEitriQuestLayout:InitMoneyBar()
    ---@type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView1 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView1:SetIconData(MoneyType.EVENT_DRAGON_TOWER_HAMMER)
    moneyBarView1.config.buttonInfo.interactable = true
    moneyBarView1.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView1:SetSize(0, 0)
    moneyBarView1.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView1:ShowInfo()
    end)
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_DRAGON_TOWER_COIN)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.listMoneyBar:Add(moneyBarView1)
    self.listMoneyBar:Add(moneyBarView2)
end

function UIEventTowerOfEitriQuestLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventTowerOfEitriQuestLayout:OnShow()
    UIEventTowerOfEitriLayout.OnShow(self)
    self:OnUpdateListQuest()
    self:InitLocalization()
    self:InitMoneyBar()
    self:StartUpdateTime()
end

function UIEventTowerOfEitriQuestLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventTowerOfEitriQuestLayout:OnHide()
    self:ReturnPoolScroll()
    self:ReturnPoolMoneyBar()
    self:RemoveUpdateTime()
    UIEventTowerOfEitriLayout.OnHide(self)
end

function UIEventTowerOfEitriQuestLayout:CreateQuestList()
    --- @param obj UIEventTowerOfEitriQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound)
        obj:AddClaimListener(function()
            if questUnitInBound.questState == QuestState.DOING then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
            elseif questUnitInBound.questState == QuestState.COMPLETED then
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("claimed"))
            else
                self:OnClickClaim(questUnitInBound.questId)
            end
        end)
        if questUnitInBound.config:IsFeatureMappingAvailable() then
            obj:SetButtonGotoData(function()
                self:OnClickGo(questUnitInBound.questId, questUnitInBound.config)
            end)
        end
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.UIEventTowerOfEitriQuestItem, onCreateItem)
end

function UIEventTowerOfEitriQuestLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_DRAGON_TOWER_DAILY_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

function UIEventTowerOfEitriQuestLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestDailySuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventTowerOfEitriTab.TOWER_QUEST)
end

function UIEventTowerOfEitriQuestLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListSortedDailyQuestData()
    local count = self.listQuestData:Count()
    self.uiScroll:Resize(count)
end

function UIEventTowerOfEitriQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(self.view.model.uiName)
    end)
end

function UIEventTowerOfEitriQuestLayout:InitUpdateTime()
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