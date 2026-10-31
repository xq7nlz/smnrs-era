--- @class UIEventSeasonalFireworkCreatorLayout : UIEventSeasonalLayout
UIEventSeasonalFireworkCreatorLayout = Class(UIEventSeasonalFireworkCreatorLayout, UIEventSeasonalLayout)

local ANIM = {
    IDLE = "idle",
    SHAKE = "action",
}

local ANIM_TIME = {
    IDLE = 2,
    SHAKE = 0.833,
}

local FX_NAME = {
    MOJITO = 1,
    COCONUT = 2,
}

local ORIGINAL_POS = U_Vector3(-406, -473, 0)
local FINAL_POS = U_Vector3(-24, -422, 0)

--- @param view UIEventSeasonalView
--- @param anchor UnityEngine_RectTransform
function UIEventSeasonalFireworkCreatorLayout:Ctor(view, tab, anchor)
    self.tab = tab
    --- @type UIEventSeasonalView
    self.view = view
    ---@type UIEventSeasonalMojitoCreatorLayoutConfig
    self.layoutConfig = nil
    ---@type Dictionary
    self.loginRewardDict = Dictionary()
    --- @type EventSeasonalConfig
    self.eventConfig = nil
    ---@type UIEventSeasonalView
    self.view = view
    ---@type boolean
    self.skipAnimation = nil
    ---@type number
    self.materialMoneyType = MoneyType.EVENT_SEASONAL_GUN_POWER
    ---@type number
    self.mojitoMoneyType = MoneyType.EVENT_SEASONAL_MOJITO
    --- @type UILoopScroll
    self.uiScroll = nil
    --- @type List
    self.listQuestData = List()
    UIEventSeasonalLayout.Ctor(self, view, tab, anchor)
end

function UIEventSeasonalFireworkCreatorLayout:SetUpLayout()
    UIEventSeasonalLayout.SetUpLayout(self)
end

function UIEventSeasonalFireworkCreatorLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_seasonal_mojito_creator_layout", self.anchor)
    UIEventSeasonalLayout.InitLayoutConfig(self, inst)
    self.mojitoConfig = self.eventConfig:GetMojitoConfig()
    self:CreateQuestList()
end

function UIEventSeasonalFireworkCreatorLayout:InitLocalization()
    UIEventSeasonalLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_firework_creator")
    self.layoutConfig.textSingleMake.text = LanguageUtils.LocalizeCommon("make_single_mojito")
    self.layoutConfig.textQuickMake.text = LanguageUtils.LocalizeCommon("quick_make")
    self.layoutConfig.subTextSubEvent.text = LanguageUtils.LocalizeCommon("seasonal_quest")
    self.layoutConfig.textTapToClose.text = LanguageUtils.LocalizeCommon("tap_to_close")
end

function UIEventSeasonalFireworkCreatorLayout:InitMoneyBar()
    --- @type List
    self.listMoneyBar = List()
    ---@type MoneyBarView
    local moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyAnchor)
    moneyBarView:SetIconData(MoneyType.EVENT_SEASONAL_GUN_POWER)
    moneyBarView.config.buttonInfo.interactable = true
    moneyBarView.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView:SetSize(0, 0)
    moneyBarView.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView:ShowInfo()
    end)
    moneyBarView:AddListener(function()
        self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
    end)
    self.listMoneyBar:Add(moneyBarView)
end

function UIEventSeasonalFireworkCreatorLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventSeasonalFireworkCreatorLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_seasonal_info"))
    end)
    self.layoutConfig.toggleSkipAnimation.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:ToggleAnimation()
    end)
    self.layoutConfig.buttonSingleMake.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        --self:MakeMojito(false)
        self:MakeMojito(false)
    end)
    self.layoutConfig.buttonQuickMake.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:MakeMojito(true)
    end)
    self.layoutConfig.subBackButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:HideAnchorQuestList()
    end)
    self.layoutConfig.buttonQuestView.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowAnchorQuestList()
    end)
    self.layoutConfig.buttonTapToClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:HideAnchorQuestList()
    end)
    self.layoutConfig.bgClose.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
        self:HideAnchorQuestList()
    end)
    self.layoutConfig.buttonCloseResult.onClick:AddListener(function()
        self:StopAllParticle()
    end)
    self.layoutConfig.buttonTest.gameObject:SetActive(false)
    self.layoutConfig.buttonTest.onClick:AddListener(function()
        self:TestAnim()
    end)
end

function UIEventSeasonalFireworkCreatorLayout:ShowTextCreateFirework()
    ---@type {moneyType, moneyValue}
    local mojitoConfig = self.eventConfig:GetMojitoConfig()
    local currentNumber = InventoryUtils.GetMoney(self.materialMoneyType)
    local itemName = LanguageUtils.LocalizeMoneyType(self.materialMoneyType)
    self.layoutConfig.textCreate.text = string.format("%s/%s %s", currentNumber, mojitoConfig.moneyValue, itemName)
end

function UIEventSeasonalFireworkCreatorLayout:OnShow()
    UIEventSeasonalLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self.skipAnimation = false
    self:InitMoneyBar()
    self:ShowTextCreateFirework()
    self:CheckQuestNotiState()
    self:SetStateSkipAnimationTick()
    self:PlaySkeletonAnim(ANIM.IDLE)
    self:StopAllParticle()
    self:SetActiveButtonCloseParticle(false)
    self:LoadMoneyIcon()
    --self:CheckNPCPos()
end

function UIEventSeasonalFireworkCreatorLayout:LoadMoneyIcon()
    self.layoutConfig.moneyIcon.sprite = ResourceLoadUtils.LoadMoneyIcon(self.materialMoneyType)
end

function UIEventSeasonalFireworkCreatorLayout:PlaySkeletonAnim(anim, time)
    self.layoutConfig.skeletonAnim.AnimationState:ClearTracks()
    if not self.layoutConfig.skeletonAnim.enabled then
        self.layoutConfig.skeletonAnim.enabled = true
    end
    local loopTime = time or 1
    if anim == ANIM.IDLE then
        self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, anim, true)
    elseif anim == ANIM.SHAKE then
        self:PlayAnimTimes(anim, loopTime)
    end
end

function UIEventSeasonalFireworkCreatorLayout:PlayAnimTimes(animName, time)
    local trackEntry = self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, animName, false)
    trackEntry:AddCompleteListenerFromLua(function()
        if time > 1 then
            self:PlayAnimTimes(animName, time - 1)
        else
            self.layoutConfig.skeletonAnim.AnimationState:SetAnimation(1, ANIM.IDLE, true)
        end
    end)
end

function UIEventSeasonalFireworkCreatorLayout:CheckQuestNotiState()
    self.layoutConfig.questNoti:SetActive(self.eventModel:HasQuestCollectionDoneButNotClaim())
end

function UIEventSeasonalFireworkCreatorLayout:ToggleAnimation()
    self.skipAnimation = not self.skipAnimation
    self:SetStateSkipAnimationTick()
end

function UIEventSeasonalFireworkCreatorLayout:SetStateSkipAnimationTick()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIEventSeasonalFireworkCreatorLayout:MakeMojito(isMultiple)
    local number = 1
    local canExchange = InventoryUtils.IsEnoughSingleResourceRequirement(
            RewardInBound.CreateBySingleParam(ResourceType.Money, self.materialMoneyType,
                    math.tointeger(number * self.mojitoConfig.moneyValue)))
    if canExchange then
        self:PlayAnimBeforeCallOpCode(isMultiple)
    else
        self:PlaySkeletonAnim(ANIM.SHAKE, 1)
    end
end

function UIEventSeasonalFireworkCreatorLayout:CallOpCode(isMultiple)
    local number = 1
    if isMultiple then
        number = math.floor(InventoryUtils.GetMoney(self.materialMoneyType) / self.mojitoConfig.moneyValue)
    end
    local rewardList
    local numberMojito

    ---@param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        numberMojito = buffer:GetInt()
        rewardList = NetworkUtils.GetRewardInBoundList(buffer)
    end
    local onSuccess = function()
        InventoryUtils.Sub(ResourceType.Money, self.materialMoneyType, math.tointeger(number * self.mojitoConfig.moneyValue))
        InventoryUtils.Add(ResourceType.Money, self.mojitoMoneyType, numberMojito)
        if rewardList ~= nil or rewardList:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList)
        end
        self.eventModel:ListCollectionQuestAddRequireNumber(numberMojito)
        self:ShowTextCreateFirework()
        self:CheckQuestNotiState()
    end
    local onFailed = function(logicCode)
        SmartPoolUtils.LogicCodeNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_SEASONAL_MOJITO_CREATE,
            UnknownOutBound.CreateInstance(PutMethod.Int, number), onSuccess, onFailed, onBufferReading)
end

------------------------------------------FxResult--------------------------------------------

function UIEventSeasonalFireworkCreatorLayout:PlayParticleByType(randomNumber)
    if randomNumber == FX_NAME.MOJITO then
        self:PlayParticle(self.layoutConfig.fxUiBarReward)
    elseif randomNumber == FX_NAME.COCONUT then
        self:PlayParticle(self.layoutConfig.fxUiCoconutReward)
    end
end

function UIEventSeasonalFireworkCreatorLayout:StopAllParticle()
    self:StopParticle(self.layoutConfig.fxUiBarReward)
    self:StopParticle(self.layoutConfig.fxUiCoconutReward)
    self:DisableIconMojitoAndCoconut()
    self:SetActiveButtonCloseParticle(false)
end

function UIEventSeasonalFireworkCreatorLayout:SetActiveButtonCloseParticle(isActive)
    self.layoutConfig.buttonCloseResult.gameObject:SetActive(isActive)
end

function UIEventSeasonalFireworkCreatorLayout:SetActiveIconMojitoOrCoconut(isMojito)
    self.layoutConfig.imgMojito.gameObject:SetActive(isMojito)
    self.layoutConfig.imgCoconut.gameObject:SetActive(not isMojito)
end

function UIEventSeasonalFireworkCreatorLayout:DisableIconMojitoAndCoconut()
    self.layoutConfig.imgMojito.gameObject:SetActive(false)
    self.layoutConfig.imgCoconut.gameObject:SetActive(false)
end

--- @param particle UnityEngine_ParticleSystem
function UIEventSeasonalFireworkCreatorLayout:PlayParticle(particle)
    particle.gameObject:SetActive(true)
    if particle.isPlaying == true then
        particle:Stop()
    end
    particle:Play()
end

--- @param particle UnityEngine_ParticleSystem
function UIEventSeasonalFireworkCreatorLayout:StopParticle(particle)
    particle:Stop()
    particle.gameObject:SetActive(false)
end

------------------------------------------Animation--------------------------------------------

function UIEventSeasonalFireworkCreatorLayout:CheckNPCPos()
    local isCenter = true
    self.layoutConfig.skeletonAnim.gameObject.transform.localPosition = ORIGINAL_POS
    ---@param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        if v.questState ~= QuestState.COMPLETED or v.questState ~= QuestState.DONE_REWARD_NOT_CLAIM then
            isCenter = false
            break
        end
    end
    if isCenter then
        self.layoutConfig.skeletonAnim.gameObject.transform.localPosition = FINAL_POS
    end
end

------------------------------------------Animation--------------------------------------------

function UIEventSeasonalFireworkCreatorLayout:TestAnim()
    if not self.skipAnimation then
        local randomNumber = math.random(FX_NAME.MOJITO, FX_NAME.COCONUT)
        local time = 3
        self:PlaySkeletonAnim(ANIM.SHAKE, time)
        self:SetButtonInteractable(false)
        self:PlayParticleByType(randomNumber)
        self:SetButtonInteractable(true)
        self:SetActiveButtonCloseParticle(true)
    else
        self:PlaySkeletonAnim(ANIM.SHAKE, 1)
    end
end

--- @return void
function UIEventSeasonalFireworkCreatorLayout:PlayAnimBeforeCallOpCode(isMultiple)
    if not self.skipAnimation then
        local randomNumber = math.random(FX_NAME.MOJITO, FX_NAME.COCONUT)
        self.coroutine = Coroutine.start(function()
            local time = 3
            self:PlaySkeletonAnim(ANIM.SHAKE, time)
            self:SetButtonInteractable(false)
            coroutine.waitforseconds(time * ANIM_TIME.SHAKE * 0.8)
            self:PlayParticleByType(randomNumber)
            coroutine.waitforseconds(time * ANIM_TIME.SHAKE * 0.2 + 0.5)
            self:CallOpCode(isMultiple)
            coroutine.waitforseconds(0.2)
            self:SetButtonInteractable(true)
            self:SetActiveButtonCloseParticle(true)
        end)
    else
        self:PlaySkeletonAnim(ANIM.SHAKE, 1)
        self:CallOpCode(isMultiple)
    end
end

--- @return void
function UIEventSeasonalFireworkCreatorLayout:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIEventSeasonalFireworkCreatorLayout:SetButtonInteractable(isInteractable)
    self.layoutConfig.buttonSingleMake.interactable = isInteractable
    self.layoutConfig.buttonQuickMake.interactable = isInteractable
    self.layoutConfig.buttonInfor.interactable = isInteractable
    self.layoutConfig.backButton.interactable = isInteractable
    self.layoutConfig.toggleSkipAnimation.interactable = isInteractable
    self.layoutConfig.buttonQuestView.interactable = isInteractable
    ---@type MoneyBarView
    local moneyBarView = self.listMoneyBar:Get(1)
    moneyBarView:RemoveAllListeners()
    moneyBarView:AddListener(function()
        if isInteractable then
            self.view:SelectTab(EventSeasonalTab.FIREWORK_SHOP)
        end
    end)
end

------------------------------------------QuestAnchor--------------------------------------------


function UIEventSeasonalFireworkCreatorLayout:ShowAnchorQuestList()
    self.layoutConfig.questAnchor:SetActive(true)
    self:OnUpdateListQuest()
    self:ShowTextCurrentMojito()
end

function UIEventSeasonalFireworkCreatorLayout:HideAnchorQuestList()
    self.layoutConfig.questAnchor:SetActive(false)
    self:ReturnPoolScroll()
    self:CheckQuestNotiState()
end

function UIEventSeasonalFireworkCreatorLayout:ShowTextCurrentMojito()
    self.layoutConfig.textNumberMojito.text = string.format("%s: %s",
            LanguageUtils.LocalizeMoneyType(self.mojitoMoneyType),
            InventoryUtils.GetMoney(self.mojitoMoneyType))
end

function UIEventSeasonalFireworkCreatorLayout:CreateQuestList()
    --- @param obj EventSeasonalQuestItem
    --- @param index number
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestUnitInBound
        local questUnitInBound = self.listQuestData:Get(dataIndex)
        obj:SetData(questUnitInBound.config, questUnitInBound)
        obj:AddClaimListener(function()
            --self:OnClickClaim(questUnitInBound.questId, questUnitInBound.config._questType)
            self:OnClickClaimListQuest()
        end)
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scroll, UIPoolType.EventSeasonalQuestItem, onCreateItem)
end

function UIEventSeasonalFireworkCreatorLayout:OnClickClaimListQuest()
    local listQuestId = List()
    ---@param v QuestUnitInBound
    for _, v in pairs(self.listQuestData:GetItems()) do
        local mainRequire = v.fixedTarget or v.config:GetMainRequirementTarget()
        if v.questState == QuestState.DONE_REWARD_NOT_CLAIM or
                (v.questState ~= QuestState.COMPLETED and v.number >= mainRequire) then
            listQuestId:Add(v.questId)
        end
    end
    self:OpCodeClaimListQuestById(listQuestId)
end

---@param questId number
function UIEventSeasonalFireworkCreatorLayout:OnClickClaim(questId)
    local opcode = OpCode.EVENT_SEASONAL_QUEST_CLAIM
    QuestDataInBound.RequestClaimQuest(opcode, questId,
            function(rewardList)
                PopupUtils.ClaimAndShowRewardList(rewardList)
                self:OnClaimQuestSuccess(questId)
            end)
end

---@param listQuestId List
function UIEventSeasonalFireworkCreatorLayout:OpCodeClaimListQuestById(listQuestId)
    if listQuestId:Count() > 0 then
        local opcode = OpCode.EVENT_SEASONAL_QUEST_CLAIM
        QuestDataInBound.RequestClaimMultiQuest(opcode, listQuestId,
                function(rewardList)
                    PopupUtils.ClaimAndShowRewardList(rewardList)
                    self:OnClaimListQuestSuccess(listQuestId)
                end)
    end
end

---@param listQuestId List
function UIEventSeasonalFireworkCreatorLayout:OnClaimListQuestSuccess(listQuestId)
    for _, id in pairs(listQuestId:GetItems()) do
        self.eventModel:OnClaimQuestCollectionSuccess(id)
    end
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventSeasonalTab.FIREWORK_CREATOR)
    self:ShowTextCreateFirework()
    --self:CheckNPCPos()
end

---@param questId number
function UIEventSeasonalFireworkCreatorLayout:OnClaimQuestSuccess(questId)
    self.eventModel:OnClaimQuestCollectionSuccess(questId)
    self:OnUpdateListQuest()
    self.view:UpdateNotificationByTab(EventSeasonalTab.FIREWORK_CREATOR)
end

function UIEventSeasonalFireworkCreatorLayout:UpdateNotification()
    local noti = false
    for i = 1, self.listQuestData:Count() do
        --- @type QuestUnitInBound
        local quest = self.listQuestData:Get(i)
        if quest.questState == QuestState.DONE_REWARD_NOT_CLAIM then
            noti = true
        end
    end
    return noti
end

function UIEventSeasonalFireworkCreatorLayout:OnUpdateListQuest()
    self.listQuestData = self.eventModel:GetListCollectionQuestData()
    self.listQuestData = QuestDataInBound.SortQuestByQuestId(self.listQuestData)
    self.listQuestData = self.eventModel:SortQuestByData(self.listQuestData)
    self:FilterTabQuest()
    self.uiScroll:Resize(self.listQuestData:Count())
end

function UIEventSeasonalFireworkCreatorLayout:FilterTabQuest()
    local questCount = self.listQuestData:Count()
    for i = questCount, 1, -1 do
        --- @type QuestUnitInBound
        local questUnitData = self.listQuestData:Get(i)
        if questUnitData.questState == QuestState.HIDDEN then
            self.listQuestData:RemoveByIndex(i)
        end
    end
end

function UIEventSeasonalFireworkCreatorLayout:ReturnPoolScroll()
    if self.uiScroll ~= nil then
        self.uiScroll:Hide()
    end
end

function UIEventSeasonalFireworkCreatorLayout:OnHide()
    UIEventSeasonalLayout.OnHide(self)
    self:SetButtonInteractable(true)
    self:ReturnPoolMoneyBar()
    self:ReturnPoolScroll()
    self:HideAnchorQuestList()
    self:StopCoroutine()
    self:DisableIconMojitoAndCoconut()
end

function UIEventSeasonalFireworkCreatorLayout:GetEventEndTime()
    return self.eventModel.timeData.endTime
end

--- @param onEventTimeEnded function
function UIEventSeasonalFireworkCreatorLayout:SetNextDayTime(onEventTimeEnded)
    self.onEventTimeEnded = onEventTimeEnded
    self:StartUpdateTime()
end

--- @param eventTimeType EventTimeType
function UIEventSeasonalFireworkCreatorLayout:OnEventTimeEnded(eventTimeType)
    RxMgr.eventStateChange:Next({ ["eventTimeType"] = eventTimeType, ["isAdded"] = false })
end

function UIEventSeasonalFireworkCreatorLayout:StartUpdateTime()
    zg.timeMgr:AddUpdateFunction(self.updateTime)
end

function UIEventSeasonalFireworkCreatorLayout:RemoveUpdateTime()
    zg.timeMgr:RemoveUpdateFunction(self.updateTime)
end

function UIEventSeasonalFireworkCreatorLayout:SetTimeRefresh()
    self.timeRefresh = zg.timeMgr:GetRemainingTime()
end

function UIEventSeasonalFireworkCreatorLayout:InitUpdateTime()
    --- @param isSetTime boolean
    self.updateTime = function(isSetTime)
        if isSetTime == true then
            self:SetTimeRefresh()
        else
            self.timeRefresh = self.timeRefresh - 1
        end
        self.layoutConfig.textEventTime.text = string.format("%s %s", LanguageUtils.LocalizeCommon("time_next_day"),
                UIUtils.SetColorString(UIUtils.green_light, TimeUtils.GetDeltaTime(self.timeRefresh)))
        if self.timeRefresh <= 0 then
            self:RemoveUpdateTime()
            if self.onEventTimeEnded then
                self.onEventTimeEnded()
            end
        end
    end
end
