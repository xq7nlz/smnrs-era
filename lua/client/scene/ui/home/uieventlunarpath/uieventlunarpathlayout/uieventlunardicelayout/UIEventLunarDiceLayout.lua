require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarDiceLayout.LunarDiceSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceRewardResult"
require "lua.client.scene.ui.home.uiEventLunarPath.uiEventLunarPathLayout.uiEventLunarDiceLayout.LunarDicePet"

--- @class UIEventLunarDiceLayout : UIEventLunarPathLayout
UIEventLunarDiceLayout = Class(UIEventLunarDiceLayout, UIEventLunarPathLayout)

--- @param view UIEventLunarPathView
--- @param lunarPathTab LunarPathTab
--- @param anchor UnityEngine_RectTransform
function UIEventLunarDiceLayout:Ctor(view, lunarPathTab, anchor)
    --- @type LunarDiceLayoutConfig
    self.layoutConfig = nil
    ---@type List -- LunarDiceSlotView
    self.diceList = nil
    ---@type List -- <LapSlotView>
    self.lapList = nil
    ---@type number
    self.rollNum = 1
    ---@type number
    self.position = 1
    ---@type number
    self.prevPosition = 1
    ---@type number
    self.lapCompleted = 1
    ---@type boolean
    self.isLimit = false
    ---@type EventDiceGameData
    self.eventDiceData = nil
    --- @type Dictionary
    self.diceSlotViewDict = Dictionary()
    --- @type LunarDicePet
    self.pet = nil
    --- @type MoneyBarView
    self.moneyBarView = nil
    UIEventLunarPathLayout.Ctor(self, view, lunarPathTab, anchor)
end

function UIEventLunarDiceLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("lunar_path_dice_layout", self.anchor)
    UIEventLunarPathLayout.InitLayoutConfig(self, inst)
    self.pet = LunarDicePet(self.layoutConfig.pet)
    self:InitLocalization()
    self:InitDiceViews()
    self:InitButtonListener()
end

function UIEventLunarDiceLayout:InitLocalization()
    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("lunar_path_dice_title")
    self.layoutConfig.textEventDesc.text = LanguageUtils.LocalizeCommon("lunar_path_dice_desc")
    self.layoutConfig.textRoll.text = LanguageUtils.LocalizeCommon("roll")

    if self.diceSlotViewDict then
        --- @param v LunarDiceSlotView
        for k, v in pairs(self.diceSlotViewDict:GetItems()) do
            v:InitLocalization()
        end
    end
end

function UIEventLunarDiceLayout:InitDiceViews()
    local childCount = self.layoutConfig.path.childCount

    --- @param slotView UnityEngine_RectTransform
    local setSlotIndex = function(slotView, index)
        local parent = self.layoutConfig.path:GetChild(index)
        --- @type LunarDiceSlotView
        local diceView = LunarDiceSlotView(slotView, index, index == childCount - 1)
        diceView:SetParent(parent)
        self.diceSlotViewDict:Add(index, diceView)
    end
    setSlotIndex(self.layoutConfig.prefabDiceSlot, 0)

    for i = 1, childCount - 1 do
        --- @type UnityEngine_GameObject
        local clone = U_GameObject.Instantiate(self.layoutConfig.prefabDiceSlot, self.layoutConfig.path)
        setSlotIndex(clone.transform, i)
    end

    self.layoutConfig.pet:SetParent(self.layoutConfig.path)
    self.layoutConfig.pet:SetAsLastSibling()
end

function UIEventLunarDiceLayout:InitButtonListener()
    self.layoutConfig.buttonRoll.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll()
    end)
end

function UIEventLunarDiceLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.layoutConfig.rollBg:SetActive(false)
    self.anchor.gameObject:SetActive(true)
    if self.moneyBarView == nil then
        self.moneyBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarView)
    end
end

function UIEventLunarDiceLayout:OnShow()
    UIEventLunarPathLayout.OnShow(self)

    self.eventDiceData = self.eventModel.eventDiceGameData

    self:SetRewardConfig()
    self:SetData()

    self.pet:PlayIdle()
end

function UIEventLunarDiceLayout:SetRewardConfig()
    local diceConfig = self.eventConfig:GetDiceConfig()
    --- @param v List | RewardInBound
    for k, v in pairs(diceConfig:GetItems()) do
        --- @type LunarDiceSlotView
        local lunarDiceSlotView = self.diceSlotViewDict:Get(k)
        if lunarDiceSlotView ~= nil then
            lunarDiceSlotView:SetReward(v:Get(1))
            lunarDiceSlotView:HideEffect()
        end
    end
end

function UIEventLunarDiceLayout:OnClickRoll()
    local onReceived = function(result)
        --- @type DiceRewardResult
        local diceResult
        local onBufferReading = function(buffer)
            diceResult = DiceRewardResult(buffer)
        end
        local onSuccess = function()
            self:OnRollSuccess(diceResult)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(self.requireList:Get(1))
    if canRoll then
        self:StartAnimRollDice()
        NetworkUtils.Request(OpCode.EVENT_LUNAR_NEW_YEAR_DICE_ROLL, nil, onReceived)
    end
end

function UIEventLunarDiceLayout:IsBigDice(index)
    local indexList = { 1, 10, 14, 23 }
    for i, v in ipairs(indexList) do
        if v == index then
            return true
        end
    end
    return false
end

function UIEventLunarDiceLayout:SetEnableArrow(check, isEnable)
    if check then
        self.arrowTransform_1.gameObject:SetActive(isEnable)
        self.arrowTransform_2.gameObject:SetActive(not isEnable)
    else
        self.arrowTransform_1.gameObject:SetActive(not isEnable)
        self.arrowTransform_2.gameObject:SetActive(isEnable)
    end
end

function UIEventLunarDiceLayout:SetEnableFrame(position, check, isEnable)
    if check then
        self.layoutConfig.select1.gameObject:SetActive(isEnable)
        self.layoutConfig.select2.gameObject:SetActive(not isEnable)
        self.layoutConfig.select1.position = position
    else
        self.layoutConfig.select1.gameObject:SetActive(not isEnable)
        self.layoutConfig.select2.gameObject:SetActive(isEnable)
        self.layoutConfig.select2.position = position
    end
end

function UIEventLunarDiceLayout:ResetSelect(isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
    self.layoutConfig.select2.gameObject:SetActive(isEnable)
end

function UIEventLunarDiceLayout:OnHide()
    UIEventLunarPathLayout.OnHide(self)
    self:HideReward()
    ClientConfigUtils.KillCoroutine(self.rollCoroutine)
    if self.moneyBarView ~= nil then
        self.moneyBarView:ReturnPool()
        self.moneyBarView = nil
    end
end

function UIEventLunarDiceLayout:HideReward()
    --- @param v LunarDiceSlotView
    for k, v in pairs(self.diceSlotViewDict:GetItems()) do
        v:HideReward()
    end
end

--- @param diceResult DiceRewardResult
function UIEventLunarDiceLayout:OnRollSuccess(diceResult)
    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_ROLL)
    self.touch = TouchUtils.Spawn("DiceRollAnimation")

    ClientConfigUtils.KillCoroutine(self.rollCoroutine)
    self.rollCoroutine = Coroutine.start(function()
        InventoryUtils.SubSingleRewardInBound(self.requireList:Get(1))
        self:ShowCurrency()
        self.view:UpdateNotificationByTab(self.lunarPathTab)

        coroutine.waitforseconds(2.5)

        self.layoutConfig.rollAnim.gameObject:SetActive(false)
        self.layoutConfig.rollImage.sprite = ResourceLoadUtils.LoadIconLunarRollDice(diceResult.diceValue)
        self.layoutConfig.rollImage.gameObject:SetActive(true)
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)

        coroutine.waitforseconds(1)

        self:PlayJumpCoroutine(self.eventDiceData.position, diceResult.newPosition, diceResult)
    end)
end

function UIEventLunarDiceLayout:SetData()
    self:ShowCurrency()

    self.requireList = self.eventConfig:GetRollRequireConfig()
    --- @type RewardInBound
    local price = self.requireList:Get(1)
    self.layoutConfig.textRollPrice.text = tonumber(price.number)

    for i = 1, self.eventDiceData.historyPositionList:Count() do
        local pos = self.eventDiceData.historyPositionList:Get(i)

        self:GetSlotView(pos):EnableClaim(true)
    end
    self:SetPetAtPos(self.eventDiceData.position)
end

function UIEventLunarDiceLayout:ShowCurrency()
    self.moneyBarView:SetIconData(MoneyType.EVENT_LUNAR_NEW_YEAR_DICE, true)
end

--- @return LunarDiceSlotView
function UIEventLunarDiceLayout:GetSlotView(pos)
    return self.diceSlotViewDict:Get(pos)
end

--- @param diceResult DiceRewardResult
function UIEventLunarDiceLayout:PlayJumpCoroutine(fromPos, toPos, diceResult)
    ClientConfigUtils.KillCoroutine(self.rollCoroutine)

    local onClickClaimed = function()
        if diceResult.newPosition == self.eventConfig:GetDiceConfig():Count() then
            self.eventDiceData:ResetLap()
            self:DoResetLap()
        end
    end

    self.rollCoroutine = Coroutine.start(function()
        local jumpTime = 0.5
        self.layoutConfig.rollBg:SetActive(false)
        for i = fromPos, toPos - 1 do
            self:DoJumpPet(i, i + 1, jumpTime)
            coroutine.waitforseconds(jumpTime)
        end
        coroutine.waitforseconds(jumpTime)

        self.layoutConfig.rollBg:SetActive(false)
        PopupUtils.ClaimAndShowRewardList(diceResult.rewards, onClickClaimed)
        self.eventDiceData:AddPositionResult(diceResult.newPosition)
        self:GetSlotView(diceResult.newPosition):EnableClaim(true)
        self.touch:Enable()
    end)
end

function UIEventLunarDiceLayout:DoJumpPet(fromPos, toPos, onComplete)
    --- @type UnityEngine_RectTransform
    local fromAnchor = self.layoutConfig.path:GetChild(fromPos)
    --- @type UnityEngine_RectTransform
    local toAnchor = self.layoutConfig.path:GetChild(toPos)

    self.pet:SetDirection(self:GetPetDirectionByPos(toPos))
    self.pet:DoJump(fromAnchor.anchoredPosition3D, toAnchor.anchoredPosition3D, function()
        --- @type LunarDiceSlotView
        local slotView = self.diceSlotViewDict:Get(toPos)
        slotView:DoShake()
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
    end, onComplete)
end

function UIEventLunarDiceLayout:SetPetAtPos(pos)
    --- @type UnityEngine_RectTransform
    local posAnchor = self.layoutConfig.path:GetChild(pos)
    self.layoutConfig.pet.anchoredPosition3D = posAnchor.anchoredPosition3D
    self.pet:SetDirection(self:GetPetDirectionByPos(pos))
end

function UIEventLunarDiceLayout:StartAnimRollDice()
    self.layoutConfig.rollImage.gameObject:SetActive(false)
    self.layoutConfig.rollAnim.gameObject:SetActive(true)
    self.layoutConfig.rollBg:SetActive(true)
    self.layoutConfig.rollAnim.AnimationState:SetAnimation(0, "roll", true)
end

function UIEventLunarDiceLayout:DoResetLap()
    self.touch = TouchUtils.Spawn("DiceReset")
    ClientConfigUtils.KillCoroutine(self.rollCoroutine)
    local lastSlot
    self.rollCoroutine = Coroutine.start(function()
        for i = 1, self.diceSlotViewDict:Count() do
            if lastSlot ~= nil then
                --- @type LunarDiceSlotView
                local lastSlotView = self.diceSlotViewDict:Get(lastSlot)
                lastSlotView:HideEffect()
            end
            --- @type LunarDiceSlotView
            local slotView = self.diceSlotViewDict:Get(i)
            if slotView then
                slotView:ShowEffect(true)
            end
            lastSlot = i
            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
            coroutine.waitforseconds(0.04)
        end
        self:SetPetAtPos(0)
        self.touch:Enable()
    end)
end

function UIEventLunarDiceLayout:GetPetDirectionByPos(pos)
    if (pos >= 0 and pos <= 9)
            or pos >= 21 then
        return 1
    end
    return -1
end