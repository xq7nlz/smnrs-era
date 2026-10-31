--- @class UIEventTowerOfEitriTowerLayout : UIEventTowerOfEitriLayout
UIEventTowerOfEitriTowerLayout = Class(UIEventTowerOfEitriTowerLayout, UIEventTowerOfEitriLayout)

local SINGLE_BUILD = 1

--- @param view UIEventAiryuuView
--- @param anchor UnityEngine_RectTransform
function UIEventTowerOfEitriTowerLayout:Ctor(view, tab, anchor)
    ---@type UIEventTowerOfEitriTowerLayoutConfig
    self.layoutConfig = nil
    --- @type EventTimeType
    self.eventTimeType = EventTimeType.EVENT_TOWER_OF_EITRI
    ---@type boolean
    self.skipAnimation = false
    --- @type MoneyBarView
    self.moneyBarView = nil
    ---@type TowerOfEitriFloorItem
    self.floorNext = nil
    ---@type TowerOfEitriFloorItem
    self.floorCurrent = nil
    ---@type ProgressBarSectionHorizontal
    self.progressBar = nil
    ---@type boolean
    self.hasClaimableQuest = false
    UIEventTowerOfEitriLayout.Ctor(self, view, tab, anchor)
end

function UIEventTowerOfEitriTowerLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("event_tower_of_eitri_tower_layout", self.anchor)
    UIEventTowerOfEitriLayout.InitLayoutConfig(self, inst)
    self:InitLocalization()
    self:InitButtonListener()
    self:GetFloor()
end

function UIEventTowerOfEitriTowerLayout:InitLocalization()
    UIEventTowerOfEitriLayout.InitLocalization(self)
    self.layoutConfig.textSubEvent.text = LanguageUtils.LocalizeCommon("tower_of_eitri_tower")
    self.layoutConfig.textTitleDetail.text = LanguageUtils.LocalizeCommon("tower_of_eitri_tower_infor")
    self.layoutConfig.textX1.text = LanguageUtils.LocalizeCommon("build")
    self.layoutConfig.textX10.text = LanguageUtils.LocalizeCommon("build")
    self.layoutConfig.textFree.text = LanguageUtils.LocalizeCommon("free")
    self.layoutConfig.textEnableAnimation.text = LanguageUtils.LocalizeCommon("skip_animation")
    self.layoutConfig.textServerBuildingProgress.text = LanguageUtils.LocalizeCommon("tower_progress")
end

function UIEventTowerOfEitriTowerLayout:InitMoneyBar()
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
    moneyBarView1:RemoveAllListeners()
    moneyBarView1:AddListener(function()
        self.view:SelectTab(EventTowerOfEitriTab.TOWER_BUNDLE)
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

function UIEventTowerOfEitriTowerLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.listMoneyBar:GetItems()) do
        v:ReturnPool()
    end
    self.listMoneyBar:Clear()
end

function UIEventTowerOfEitriTowerLayout:InitButtonListener()
    self.layoutConfig.backButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:CloseLayout()
    end)
    self.layoutConfig.buttonInfor.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("event_tower_of_eitri_tower_info"))
    end)
    self.layoutConfig.buttonX1.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuild(1)
    end)
    self.layoutConfig.buttonX10.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuild(10)
    end)
    self.layoutConfig.buttonReward.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickShowPoolReward()
    end)
    self.layoutConfig.checkbox.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckbox()
    end)
    self.layoutConfig.buttonServerBuildingProgress.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:ShowPopupServerBuilding()
    end)
end

---@param numberBuild number
function UIEventTowerOfEitriTowerLayout:OnClickBuild(numberBuild)
    self.towerBuildFreeDaily = self.eventModel:GeTowerBuildFreeDaily()
    if numberBuild > SINGLE_BUILD or self.towerBuildFreeDaily >= self.eventConfig:GetEventTowerConfig().dailyFree then
        local canOpen = InventoryUtils.IsEnoughSingleResourceRequirement(
                RewardInBound.CreateBySingleParam(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_HAMMER, numberBuild))
        if canOpen then
            self:PlayAinmBeforeCallOpcode(numberBuild)
        end
    else
        self:PlayAinmBeforeCallOpcode(numberBuild, true)
    end
end

function UIEventTowerOfEitriTowerLayout:PlayAinmBeforeCallOpcode(numberBuild, isFree)
    if not self.skipAnimation then
        self:PlayAnimation(numberBuild)
        self.coroutine = Coroutine.start(function()
            self:SetButtonInteractable(false)
            coroutine.waitforseconds(2)
            self:CallOpcode(numberBuild, isFree)
            coroutine.waitforseconds(1)
            self:SetButtonInteractable(true)
        end)
    else
        self.coroutine = Coroutine.start(function()
            self:SetButtonInteractable(false)
            coroutine.waitforseconds(0.4)
            self:CallOpcode(numberBuild, isFree)
            coroutine.waitforseconds(0.1)
            self:SetButtonInteractable(true)
        end)
    end
end

function UIEventTowerOfEitriTowerLayout:CallOpcode(numberBuild, isFreeOpen)
    if PopupUtils.IsPopupShowing(UIPopupName.UIPopupNotification) then
        PopupMgr.HidePopup(UIPopupName.UIPopupNotification)
    end
    ---@type List
    local rewardList1 = List()
    ---@type List
    local rewardList2 = List()
    ---@type List
    local listIconData = List()
    ---@type List
    local listIconData2 = List()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        rewardList1 = NetworkUtils.GetRewardInBoundList(buffer)
        rewardList2 = NetworkUtils.GetRewardInBoundList(buffer)
    end

    local onSuccess = function()
        if not isFreeOpen then
            InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_DRAGON_TOWER_HAMMER, numberBuild)
            self.eventModel:ListTowerQuestAddCurrentNumber(numberBuild)
            self:CheckServerProgressNoti()
            self:EnableNotiServerProgress(self.hasClaimableQuest)
        else
            self.eventModel:AddTowerBuildFreeDaily()
        end
        self.eventModel:AddTowerCurrentFloor(numberBuild)
        TrackingUtils.AddFireBaseClickButtonEvent(FBEvents.EVENT_DRAGON_TOWER, self.eventModel:GetTowerCurrentFloor())
        if self.skipAnimation then
            self:SetFloorData()
        end
        if rewardList2 ~= nil and rewardList2:Count() > 0 then
            --- @param v ItemIconData
            for _, v in pairs(rewardList2:GetItems()) do
                v:AddToInventory()
                listIconData2:Add(v:GetIconData())
            end
            --- @param v ItemIconData
            for _, v in pairs(rewardList1:GetItems()) do
                v:AddToInventory()
                listIconData:Add(v:GetIconData())
            end
            PopupUtils.ClaimAndShowSplitReward(listIconData, listIconData2, nil, "golden_floor_reward_bonus")
        elseif rewardList1 ~= nil or rewardList1:Count() > 0 then
            PopupUtils.ClaimAndShowRewardList(rewardList1)
        end
        self:SetButton()
    end
    local isFree = isFreeOpen or false

    local outBound = UnknownOutBound.CreateInstance(PutMethod.Int, numberBuild, PutMethod.Bool, isFree)

    local onFailed = function(logicCode)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("failed"))
        SmartPoolUtils.ShowShortNotification(logicCode)
    end
    NetworkUtils.RequestAndCallback(OpCode.EVENT_DRAGON_TOWER_OPEN, outBound, onSuccess, onFailed, onBufferReading)
end

function UIEventTowerOfEitriTowerLayout:SetButtonInteractable(isInteractable)
    self.layoutConfig.backButton.interactable = isInteractable
    self.layoutConfig.buttonInfor.interactable = isInteractable
    self.layoutConfig.buttonReward.interactable = isInteractable
    self.layoutConfig.checkbox.interactable = isInteractable
    self.layoutConfig.buttonServerBuildingProgress.interactable = isInteractable
    self.layoutConfig.buttonX10.interactable = isInteractable
    self.layoutConfig.buttonX1.interactable = isInteractable
    ---@type MoneyBarView
    local moneyBarView1 = self.listMoneyBar:Get(1)
    moneyBarView1:RemoveAllListeners()
    moneyBarView1:AddListener(function()
        if isInteractable then
            self.view:SelectTab(EventTowerOfEitriTab.TOWER_BUNDLE)
        end
    end)
end

function UIEventTowerOfEitriTowerLayout:SetButton()
    local remain = self.eventModel.config:GetEventTowerConfig().dailyFree - self.eventModel:GeTowerBuildFreeDaily()
    self.layoutConfig.textFree.gameObject:SetActive(remain > 0)
    self.layoutConfig.textX1.gameObject:SetActive(not (remain > 0))
    self.layoutConfig.notiFree.gameObject:SetActive(remain > 0)
    self.layoutConfig.textFreeRemain.gameObject:SetActive(remain > 0)
    self.layoutConfig.textFreeRemain.text = string.format("%s: %s", LanguageUtils.LocalizeCommon("remaining"), UIUtils.SetColorString(UIUtils.green_light, remain))
end

function UIEventTowerOfEitriTowerLayout:ResetTowerPosition()
    ---@type UnityEngine_Vector3
    local pos = self.layoutConfig.floorAnchor.transform.position
    pos.y = 0
    self.layoutConfig.floorAnchor.transform.position = pos
end

function UIEventTowerOfEitriTowerLayout:UpdateTowerData(numberBuild)
    local floorCurrent = self.eventModel:GetTowerCurrentFloor() + numberBuild
    self:SetFloorData(floorCurrent)
end

function UIEventTowerOfEitriTowerLayout:PlayAnimation(numberBuild)
    if numberBuild > SINGLE_BUILD then
        local data = {}
        data.floorId = self.eventModel:GetTowerCurrentFloor() + 10
        data.goldenFloorConfig = self.eventConfig:GetEventTowerConfig().goldenIntervalFloor
        self.floorNext:SetItemData(data)
    end
    self:ResetTowerPosition()
    self.floorNext:EnableFloorSprite(false)
    self.floorNext:EnableGoldenFloor(false)
    ---@type UnityEngine_Vector3
    local pos = self.layoutConfig.floorAnchor.transform.position
    self.coroutine = Coroutine.start(function()
        self.floorNext:SetFloorEnable(true)
        self.floorNext:PlayAnimBuildFloor(true)
        self.floorNext:EnableBuildFloorFx(true)
        coroutine.waitforseconds(1.33)
        self.floorNext:EnableFloorSprite(true)
        self.floorNext:PlayAnimBuildFloor(false)
        self.floorNext:EnableGoldenFloor(true)
        coroutine.waitforseconds(0.5)
        while true do
            coroutine.waitforendofframe()
            if pos.y <= -2.92 then
                self.layoutConfig.floorAnchor.transform.position = pos
                break
            else
                pos.y = pos.y - 0.4
                self.layoutConfig.floorAnchor.transform.position = pos
            end
        end
        self:UpdateTowerData(numberBuild)
        self.floorCurrent:EnableGoldenFloor(true)
        self.floorNext:ClearFloorCache()
        self:ResetTowerPosition()
    end)
end

--- @return void
function UIEventTowerOfEitriTowerLayout:StopCoroutine()
    if self.coroutine ~= nil then
        Coroutine.stop(self.coroutine)
        self.coroutine = nil
    end
end

function UIEventTowerOfEitriTowerLayout:OnClickShowPoolReward()
    local data = {}
    local localize = {}
    localize.key1 = "normal_floor_reward"
    localize.key2 = "golden_floor_reward_bonus"
    data.uiPoolType = UIPoolType.RateView
    data.localize = localize
    data.listRewardIconData = self.eventConfig:GetNormalFloorRewardConfig()
    data.listRewardIconData2 = self.eventConfig:GetGoldenFloorRewardConfig()
    PopupMgr.ShowPopup(UIPopupName.UIShowItemInRandomPoolSplit, data)
end

function UIEventTowerOfEitriTowerLayout:OnClickCheckbox()
    self.skipAnimation = not self.skipAnimation
    self:InitTickEnableAnimation()
end

function UIEventTowerOfEitriTowerLayout:InitTickEnableAnimation()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIEventTowerOfEitriTowerLayout:GetFloor()
    require "lua.client.scene.ui.home.uiEventTowerOfEitri.layout.tower.TowerOfEitriFloorItem"
    self.floorNext = TowerOfEitriFloorItem(self.layoutConfig.floorAnchor.transform:GetChild(0))
    self.floorCurrent = TowerOfEitriFloorItem(self.layoutConfig.floorAnchor.transform:GetChild(1))
end

function UIEventTowerOfEitriTowerLayout:SetFloorData(floor)
    local data = {}
    local floorCurrent = floor or self.eventModel:GetTowerCurrentFloor()
    data.floorId = floorCurrent
    data.goldenFloorConfig = self.eventConfig:GetEventTowerConfig().goldenIntervalFloor
    self.floorCurrent:SetItemData(data)
    data.floorId = floorCurrent + 1
    self.floorNext:SetItemData(data)
end

function UIEventTowerOfEitriTowerLayout:EnableButtonClosePopupInteractable(isEnable)
    self.layoutConfig.progressBarBgClose.interactable = isEnable
end

function UIEventTowerOfEitriTowerLayout:ShowPopupServerBuilding()
    local listQuestData = self.eventModel:GetListSortedTowerQuestData()
    local targetDict = Dictionary()
    ---@param v QuestUnitInBound
    for k, v in pairs(listQuestData:GetItems()) do
        ---@type {requireValue, listReward : List, isClaimed, currentValue, localize}
        local data = {}
        data.listReward = RewardInBound.GetItemIconDataList(v.config:GetListReward())
        data.isClaimed = v.questState == QuestState.COMPLETED
        data.currentValue = v.number
        data.requireValue = v.config:GetMainRequirementTarget()
        data.localize = LanguageUtils.LocalizeQuestDescription(v.questId, v.config)
        targetDict:Add(k, data)
    end
    ---@type {titleText, localize, itemDict|Dictionary, type,isOneButton, buttonClaim}
    local data = {}
    data.titleText = LanguageUtils.LocalizeCommon("reward")
    data.itemDict = targetDict
    data.type = PopupMulti.TowerOfEitriPopupQuestItem
    data.isOneButton = true
    local buttonClaimData = {}
    buttonClaimData.localize = LanguageUtils.LocalizeCommon("claim_and_close")
    buttonClaimData.OnClick = function()
        if self.hasClaimableQuest then
            local opcode = OpCode.EVENT_DRAGON_TOWER_BUILDING_QUEST_CLAIM
            QuestDataInBound.RequestClaimAllQuestReturnListQuestId(opcode, nil,
                    function(rewardList, listQuestId)
                        PopupUtils.ClaimAndShowRewardList(rewardList)
                        self:EnableNotiServerProgress(false)
                        self:OnClaimListQuestSuccess(listQuestId)
                        self:CheckServerProgressNoti()
                    end)
            PopupMgr.HidePopup(UIPopupName.UIPopupMultiScrollRewardItem)
        else
            SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("not_thing_to_claim"))
        end
    end
    data.buttonClaim = buttonClaimData
    PopupMgr.ShowPopup(UIPopupName.UIPopupMultiScrollRewardItem, data)
end

---@param listQuestId List
function UIEventTowerOfEitriTowerLayout:OnClaimListQuestSuccess(listQuestId)
    for _, questId in pairs(listQuestId:GetItems()) do
        self.eventModel:OnClaimQuestTowerSuccess(questId)
    end
end

function UIEventTowerOfEitriTowerLayout:EnableNotiServerProgress(isEnable)
    self.layoutConfig.notiServerBuildingProgress:SetActive(isEnable)
end

function UIEventTowerOfEitriTowerLayout:CheckServerProgressNoti()
    self.hasClaimableQuest = self.eventModel:HasClaimableTowerQuest()
end

function UIEventTowerOfEitriTowerLayout:OnShow()
    UIEventTowerOfEitriLayout.OnShow(self)
    self.anchor.gameObject:SetActive(true)
    self:CheckServerProgressNoti()
    self:InitTickEnableAnimation()
    self:InitMoneyBar()
    self:SetButton()
    self:SetButtonInteractable(true)
    self.floorNext:SetFloorEnable(false)
    self:SetFloorData()
    self:ResetTowerPosition()
    self:EnableNotiServerProgress(self.hasClaimableQuest)
end

function UIEventTowerOfEitriTowerLayout:SetUpLayout()
    UIEventTowerOfEitriLayout.SetUpLayout(self)
end

function UIEventTowerOfEitriTowerLayout:OnHide()
    UIEventTowerOfEitriLayout.OnHide(self)
    self:ReturnPoolMoneyBar()
    self.view:SetCurrentFloor(self.eventModel:GetTowerCurrentFloor())
    self:StopCoroutine()
end

