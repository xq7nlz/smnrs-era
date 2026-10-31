require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.UIEventSkinChallengeLayout"
require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.questLayout.SkinChallengeNodeView"
require "lua.client.scene.ui.home.uiEventSkinChallenge.layout.questLayout.UIEventSkinChallengeQuestDetailLayout"

local SkinChallengeQuestButton = {
    Bundle = 1,
    Exchange = 2,
}

--- @class UIEventSkinChallengeQuestLayout : UIEventSkinChallengeLayout
UIEventSkinChallengeQuestLayout = Class(UIEventSkinChallengeQuestLayout, UIEventSkinChallengeLayout)

--- @param view UIEventSkinChallengeView
--- @param EventZodiacTab EventZodiacTab
--- @param anchor UnityEngine_RectTransform
---@param noti UnityEngine_GameObject
function UIEventSkinChallengeQuestLayout:Ctor(view, EventZodiacTab, anchor, noti)
    ---@type UIEventSkinChallengeView
    self.view = view
    self.noti = noti
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    --- @type List
    self.listChallengeNodes = List()
    --- @type UIEventSkinChallengeQuestLayoutConfig
    self.layoutConfig = nil
    --- @type List
    self.skinChallengeNode = nil
    --- @type boolean
    self.hasNoti = self:HasNoti()
    --- @type UIEventSkinChallengeQuestDetailLayout
    self.uiQuestDetailView = nil
    --- @type ProgressBarView
    self.progressBarView = nil
    UIEventSkinChallengeLayout.Ctor(self, view, EventZodiacTab, anchor)
end

--- @param objectView UnityEngine_GameObject
function UIEventSkinChallengeQuestLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("ui_event_skin_challenge_quest_layout", self.anchor)
    UIEventSkinChallengeLayout.InitLayoutConfig(self, inst)
    self.uiQuestDetailView = UIEventSkinChallengeQuestDetailLayout(self, self.layoutConfig.questDetailAnchor)
    self:InitButtons()
    self:InitListChallengeNode()
    self:InitUpdateTime()
end

function UIEventSkinChallengeQuestLayout:InitLocalization()
    self.layoutConfig.textEventName.text = ""
    self.layoutConfig.textEventTittle.text = LanguageUtils.LocalizeCommon("title_event_skin_challenge")
    self.layoutConfig.localizeBundle.text = LanguageUtils.LocalizeCommon("skin_bundle")
    self.layoutConfig.localizeExchange.text = LanguageUtils.LocalizeCommon("exchange")
end

function UIEventSkinChallengeQuestLayout:SetUpLayout()
    UIEventSkinChallengeLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end

function UIEventSkinChallengeQuestLayout:InitButtons()
    self.layoutConfig.buttonBack.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonGreen.onClick:AddListener(function()
        self:InitListQuestNode()
    end)
    self.layoutConfig.buttonExchange.onClick:AddListener(function()
        self.view:SelectTab(EventSkinChallengeTab.EXCHANGE)
    end)
    self.layoutConfig.buttonBundle.onClick:AddListener(function()
        self.view:SelectTab(EventSkinChallengeTab.BUNDLE)
    end)
end

function UIEventSkinChallengeQuestLayout:InitMoneyBar()
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
        self.moneyBarView:SetIconData(MoneyType.SKIN_BADGE)
    end
end

function UIEventSkinChallengeQuestLayout:ReturnPoolMoneyBar()
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventSkinChallengeQuestLayout:OnShow()
    UIEventSkinChallengeLayout.OnShow(self)
    self.model = self.view.eventModel
    self:InitLocalization()
    self:SetEndEventTime(self:_GetEventEndTime(), function()
        self:_OnEventTimeEnded()
    end)
    self:InitMoneyBar()
    self:UpdateProgressTableView()
    self:UpdateListChallengeNode()
end

function UIEventSkinChallengeQuestLayout:InitListChallengeNode()
    local length = self.layoutConfig.listNode.childCount
    for i = 1, length do
        ---@type SkinChallengeNodeView
        local node = SkinChallengeNodeView(self.layoutConfig.listNode:GetChild(i - 1))
        self.listChallengeNodes:Add(node)
    end
end

function UIEventSkinChallengeQuestLayout:UpdateListChallengeNode()
    for i, node in ipairs(self.listChallengeNodes:GetItems()) do
        local nextNode
        local lineAngles
        if i < self.listChallengeNodes:Count() then
            nextNode = SkinChallengeNodeView(self.layoutConfig.listNode:GetChild(i))
            local vectorBetween = nextNode.config.transform.position - node.config.transform.position
            local angle = U_Vector3.SignedAngle(U_Vector3.down, vectorBetween, U_Vector3.forward)
            lineAngles = U_Vector3(0, 0, angle)
        end
        --[[        if i == self.listChallengeNodes:Count() then
                    node.config.frameActive.sprite = ResourceLoadUtils.LoadSkinChallengeNodeImage(self.eventModel.selectionId, self.eventModel.timeData.dataId)
                    node.config.frameActive:SetNativeSize()
                    node.config.textSkinName.text = LanguageUtils.LocalizeSkinName(self.eventConfig:GetSkinIdBySelectionId(self.eventModel.selectionId))
                end]]
        local rewardState = self.eventModel.dayRewardStateDict:GetOrDefault(i, RewardState.NOT_AVAILABLE_TO_CLAIM)
        if i == self.eventModel.dayRewardStateDict:Count() and rewardState == RewardState.NOT_AVAILABLE_TO_CLAIM then
            rewardState = -1
        end

        node:SetData({ dayId = i, rewardState = rewardState, lineAngles = lineAngles })
        node:AddListener(function()
            if i <= self.eventModel.dayRewardStateDict:Count() then
                self.uiQuestDetailView:OnShow({
                    listQuestData = self.eventModel:GetListQuestDataByDay(i),
                    --listRewardPreview = self.eventConfig:GetDictRewardChallengeByDay(i):GetAllRewardsBySelectionId(self.eventModel.selectionId),
                    listRewardPreview = self.eventConfig:GetListRewardChallengeByDay(i),
                    rewardState = rewardState
                })
                self.uiQuestDetailView:AddClaimListener(function()
                    if rewardState ~= RewardState.CLAIMED then
                        self:OnClickClaim(i)
                    else
                        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
                    end
                end, RewardState.CLAIMED)
            else
                SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_available_day"))
            end
        end)
    end
end

function UIEventSkinChallengeQuestLayout:HasNoti()
end

function UIEventSkinChallengeQuestLayout:OnHide()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
    if self.uiQuestDetailView ~= nil then
        self.uiQuestDetailView:OnHide()
    end
    if self.progressBarView ~= nil then
        self.progressBarView:ReturnPool()
    end
    self:ReturnPoolMoneyBar()
    self:RemoveUpdateTime()
    UIEventSkinChallengeLayout.OnHide(self)
end

function UIEventSkinChallengeQuestLayout:OnClickClaim(dayId)
    local opCode
    --if dayId == self.eventModel.dictQuestData:Count() then
    --    if InventoryUtils.IsEnoughSingleResourceRequirement(self.eventConfig:GetFinalRewardInBound(), true) then
    --        opCode = OpCode.EVENT_SKIN_CHALLENGE_FINAL_QUEST_CLAIM
    --    else
    --        return
    --    end
    --else
    opCode = OpCode.EVENT_SKIN_CHALLENGE_QUEST_CLAIM
    --end
    local onReceived = function(result)
        --- @param buffer UnifiedNetwork_ByteBuf
        local onBufferReading = function(buffer)
            local rewardList = NetworkUtils.GetRewardInBoundList(buffer)
            if rewardList:Count() > 0 then
                PopupUtils.ClaimAndShowRewardList(rewardList)
            end
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        local onClaimSuccess = function()
            if opCode == OpCode.EVENT_SKIN_CHALLENGE_FINAL_QUEST_CLAIM then
                self.eventModel:ClearMoneyType()
            end
            self:OnClaimChallengeSuccess(dayId)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onClaimSuccess, onFailed)
    end
    NetworkUtils.Request(opCode, UnknownOutBound.CreateInstance(PutMethod.Int, dayId), onReceived)
end

function UIEventSkinChallengeQuestLayout:OnClaimChallengeSuccess(dayId)
    self.eventModel:OnClaimChallengeSuccess(dayId)
    self:UpdateListChallengeNode()
    self:UpdateChallengeLayoutDetail(dayId)
    self:UpdateProgressTableView()
end

function UIEventSkinChallengeQuestLayout:UpdateChallengeLayoutDetail(dayId)
    self.uiQuestDetailView:OnShow({
        listQuestData = self.eventModel:GetListQuestDataByDay(dayId),
        --listRewardPreview = self.eventConfig:GetDictRewardChallengeByDay(dayId):GetAllRewardsBySelectionId(self.eventModel.selectionId),
        listRewardPreview = self.eventConfig:GetListRewardChallengeByDay(dayId),
        rewardState = RewardState.CLAIMED
    })
    self.uiQuestDetailView:AddClaimListener(function()
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reward_claimed"))
    end)
end

function UIEventSkinChallengeQuestLayout:UpdateNotification()
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

function UIEventSkinChallengeQuestLayout:OnUpdateListQuest()

end

function UIEventSkinChallengeQuestLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventSkinChallengeQuestLayout:OnClickGo(questId, questElementConfig)
    QuestDataInBound.GoQuest(questId, questElementConfig, function()
        PopupMgr.HidePopup(UIPopupName.UIEventSkinChallenge)
    end)
end

function UIEventSkinChallengeQuestLayout:_InitProgressTableView()
    self.progressBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ProgressBarView, self.layoutConfig.moneyAnchor)
end

function UIEventSkinChallengeQuestLayout:UpdateProgressTableView()
    --[[    self:_InitProgressTableView()
        local data = {}
        data.progressValue = InventoryUtils.GetMoney(self.eventConfig:GetFinalRewardInBound().id)
        data.maxProgressValue = self.eventConfig:GetFinalRewardInBound().number
        data.iconData = self.eventConfig:GetFinalRewardInBound():GetIconData()

        self.progressBarView:SetData(data)
        self.progressBarView:SetBarSize(U_Vector2(298, 32))]]
end

function UIEventSkinChallengeQuestLayout:_InitMoneyTableView()
    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyAnchor, nil, UIPoolType.MoneyBarView)
end

--- @return void
function UIEventSkinChallengeQuestLayout:_InitMoneyBar()
    self:SetUpMoneyBar(MoneyType.SKIN_BADGE)
end

function UIEventSkinChallengeQuestLayout:SetUpMoneyBar(...)
    local args = { ... }
    local moneyList = List()
    for i = 1, #args do
        moneyList:Add(args[i])
    end
    self.moneyTableView:SetData(moneyList)
end

function UIEventSkinChallengeQuestLayout:_GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param endTime number
--- @param onEventTimeEnded function
function UIEventSkinChallengeQuestLayout:SetEndEventTime(endTime, onEventTimeEnded)
    self.endTime = endTime
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSkinChallengeQuestLayout:_OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSkinChallengeQuestLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeQuestLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSkinChallengeQuestLayout:SetTimeRefresh()
    self.timeRefresh = self.endTime - zg.timeMgr:GetServerTime()
end

function UIEventSkinChallengeQuestLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("will_end_in"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end