require "lua.client.data.Event.EventHalloweenConfig"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceRewardResult"
require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.lottery.LotteryResult"

local TIME_TO_ROLL = 0.15
--- @class UIEventNewYearLotteryLayout : UIEventNewYearLayout
UIEventNewYearLotteryLayout = Class(UIEventNewYearLotteryLayout, UIEventNewYearLayout)

function UIEventNewYearLotteryLayout:Ctor(view, tab, anchor)
    --- @type LotteryLayoutConfig
    self.layoutConfig = nil
    ---@type List<DiceSlotView>
    self.diceList = nil

    ---@type EventDiceGameData
    self.eventDiceData = nil

    self.arrowTransform_1 = nil

    self.arrowTransform_2 = nil
    UIEventNewYearLayout.Ctor(self, view, tab, anchor)

    self.moneyTypeShow = MoneyType.EVENT_NEW_YEAR_LOTTERY_TICKET

    self.posMarked = List()
end

function UIEventNewYearLotteryLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("new_year_lottery_layout", self.anchor)
    UIEventNewYearLayout.InitLayoutConfig(self, inst)
    self.arrowTransform_1 = self.layoutConfig.select1:GetChild(0)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitLocalization()
    self:GetModelConfig()
    self:InitDiceViews()
    self:InitButtons()
end

function UIEventNewYearLotteryLayout:InitButtons()
    self.layoutConfig.rollButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll()
    end)

    self.layoutConfig.resetButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnResetLottery()
    end)
end

function UIEventNewYearLotteryLayout:InitDiceViews()
    if self.diceList == nil then
        self.diceList = List()
    end
    local effectScale = U_Vector3(0.365, 0.365, 0.365)
    local frameScale = U_Vector3(0.73, 0.73, 0.73)
    local dicList = self.eventConfig:GetLotteryData()
    for i = 1, self.layoutConfig.diceRollContainer.childCount do
        local reward = dicList:Get(i)
        local diceView = DiceSlotView(self.layoutConfig.diceRollContainer:GetChild(i - 1), i)
        diceView:SetReward(reward)
        diceView:IsEnableBg(false)
        diceView:SetScale(effectScale, frameScale)
        self.diceList:Add(diceView)
    end
end

function UIEventNewYearLotteryLayout:UpdateDiceViews()
    for i = 1, self.diceList:Count() do
        local view = self.diceList:Get(i)
        for j = 1, self.posList:Count() do
            local temp = self.posList:Get(j)
            if i == temp then
                view:SetView(true)
                break
            end
        end
    end
end

function UIEventNewYearLotteryLayout:IsInPosList(index)
    for j = 1, self.posList:Count() do
        local temp = self.posList:Get(j)
        if index == temp then
            return true
        end
    end
    return false
end

function UIEventNewYearLotteryLayout:ResetDiceViews(showEffect)
    for i = 1, self.diceList:Count() do
        local view = self.diceList:Get(i)
        view:SetView(false)
        if showEffect ~= nil then
            view:ShowEffect()
        end
    end
    self.first = nil
end

function UIEventNewYearLotteryLayout:InitLocalization()
    self.layoutConfig.diceTitle.text = LanguageUtils.LocalizeCommon("event_lottery_title")
    self.layoutConfig.rollText.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.textReset.text = LanguageUtils.LocalizeCommon("reset")
end

function UIEventNewYearLotteryLayout:SetUpLayout()
    UIEventNewYearLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end
function UIEventNewYearLotteryLayout:OnShow()
    UIEventNewYearLayout.OnShow(self)
    self:FillData()
    self:UpdateRequireView()
end

function UIEventNewYearLotteryLayout:FillData()
    --- @type MoneyBarView
    self.diceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.diceBarAnchor)
    self.diceBarView:SetIconData(self.moneyTypeShow)
    self.diceBarView:AddListener(function()
        self:OnClickMoneyBar()
    end)

    self.rollNum = self.eventModel.lotteryData.numberRoll + 1
    self.posList = self.eventModel:GetOpenedLottery()

    self:UpdateDiceViews()
    self:UpdateCurrentDiceView(true)
    --self:UpdatePosMarked()
end

function UIEventNewYearLotteryLayout:UpdatePosMarked()
    local check = false
    for i = 1, self.diceList:Count() do
        for j = 1, self.posList:Count() do
            if i == self.posList:Get(j) then
                check = true
                break
            end
        end
        if check then
            check = false
        else
            self.posMarked:Add(i)
        end
    end
end

function UIEventNewYearLotteryLayout:UpdateCurrentDiceView(needDelay)
    self:SetEnableFrame(nil, false)
    -------@type DiceSlotView
    --local update = function()
    --    --- this index need to load from server
    --    local index = 1
    --    local view = self.diceList:Get(index)
    --    self:SetEnableArrow(false)
    --    self:SetEnableFrame(view.config.transform.position, true)
    --end
    --if needDelay ~= nil and needDelay then
    --    Coroutine.start(function()
    --        coroutine.waitforendofframe()
    --        update()
    --    end)
    --else
    --    update()
    --end
end

function UIEventNewYearLotteryLayout:UpdateRequireView()
    if self.requireList == nil then
        self.requireList = self.eventConfig:GetRollRequireConfig()
    end
    if self.rollNum > self.requireList:Count() then
        self.layoutConfig.rollButton.gameObject:SetActive(false)
    else
        self.layoutConfig.rollButton.gameObject:SetActive(true)
        self.layoutConfig.requireText.text = self.requireList:Get(self.rollNum).number
    end
    local currentRollTurn = self.rollNum - 1
    if currentRollTurn >= 12 then
        self.layoutConfig.resetButton.gameObject:SetActive(true)
    else
        self.layoutConfig.resetButton.gameObject:SetActive(false)
    end
end

function UIEventNewYearLotteryLayout:OnResetLottery()
    local yesCallBack = function()
        local onSuccess = function()
            self.touch = TouchUtils.Spawn("LotteryOnResetLottery")
            Coroutine.start(function()
                local count = 3
                self:SetEnableArrow(false)
                self:SetEnableFrame(nil, false)
                local time = 0.05
                for j = 1, count do
                    for i = 1, self.diceList:Count() do
                        --- @type DiceSlotView
                        local _diceView = self.diceList:Get(i)
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        _diceView:SetEnableFrame(true)
                        coroutine.waitforseconds(time)
                    end
                end
                coroutine.waitforseconds(0.5)
                count = 1
                for j = 1, count do
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    for i = 1, self.diceList:Count() do
                        --- @type DiceSlotView
                        local _diceView = self.diceList:Get(i)
                        _diceView:SetEnableFrame(true)
                    end
                    coroutine.waitforseconds(0.6)
                end
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                self:ResetDiceViews(true)
                self.eventModel.lotteryData.numberRoll = 0
                self.posList:Clear()
                self.rollNum = 1
                self:UpdateRequireView()
                self.touch:Enable()
            end)
        end
        local onFailed = function(logicCode)
            SmartPoolUtils.LogicCodeNotification(logicCode)
        end
        NetworkUtils.RequestAndCallback(OpCode.EVENT_NEW_YEAR_LOTTERY_RESET, nil, onSuccess, onFailed)
    end

    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_reset"), nil, yesCallBack)
end

function UIEventNewYearLotteryLayout:ResetDiceViews(showEffect)
    for i = 1, self.diceList:Count() do
        local view = self.diceList:Get(i)
        view:SetView(false)
        if showEffect ~= nil then
            view:ShowEffect()
        end
    end
    self.first = nil
    --if self.posList ~= nil then
    --    self.posList:Clear()
    --end
end

function UIEventNewYearLotteryLayout:OnClickRoll()
    local onReceived = function(result)
        --- @type LotteryResult
        local diceResult
        local onBufferReading = function(buffer)
            diceResult = LotteryResult(buffer)
        end
        local onSuccess = function()
            self.touch = TouchUtils.Spawn("LotteryOnClickRoll")
            Coroutine.start(function()
                self.index = 0
                self:SetEnableArrow(false)
                self.prev = -1
                local rollCount = 50
                local time = 0.03 * (self.posList:Count() / 5 + 1)
                ---@type DiceSlotView
                local diceView = nil
                for i = 1, rollCount do
                    self.index = math.random(1, self.diceList:Count())
                    if not self:IsInPosList(self.index) and self.prev ~= self.index then
                        self.prev = self.index
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                        diceView = self.diceList:Get(self.index)
                        local pos = diceView.config.transform.position
                        self:SetEnableFrame(pos, true)
                        time = time + U_Time.deltaTime / (rollCount - i + 1) * 4
                        coroutine.waitforseconds(time)
                        self:SetEnableFrame(pos, false)
                    end
                end
                coroutine.waitforseconds(0.05)
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                --- this index load from server data
                local index = diceResult.idLotteryReward
                diceView = self.diceList:Get(index)
                diceView:SetView(true)
                diceView:ShowRewardInbound()
                local pos = diceView.config.transform.position
                self:SetEnableFrame(pos, true)
                self:SetEnableArrow(true)
                InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_NEW_YEAR_LOTTERY_TICKET, self.requireList:Get(self.rollNum).number)
                self.rollNum = self.rollNum + 1
                self.eventModel.lotteryData.numberRoll = self.eventModel.lotteryData.numberRoll + 1
                self.eventModel:GetOpenedLottery():Add(index)
                self:UpdateRequireView()
                self.touch:Enable()
            end)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(self.requireList:Get(self.rollNum))
    if canRoll then
        NetworkUtils.Request(OpCode.EVENT_NEW_YEAR_LOTTERY_ROLL, nil, onReceived)
    end
end

function UIEventNewYearLotteryLayout:SetEnableArrow(isEnable)
    self.arrowTransform_1.gameObject:SetActive(isEnable)
end

function UIEventNewYearLotteryLayout:SetEnableFrame(position, isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
    if position ~= nil then
        self.layoutConfig.select1.position = position
    end
end

function UIEventNewYearLotteryLayout:ResetSelect(isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
end

function UIEventNewYearLotteryLayout:OnHide()
    self:ResetDiceViews()
    self:UpdateCurrentDiceView()
    if self.diceBarView ~= nil then
        self.diceBarView:ReturnPool()
        self.diceBarView = nil
    end
end

function UIEventNewYearLotteryLayout:OnClickMoneyBar()
    self.view:SelectTab(self.model.listSubEvent:Get(NewYearTab.BUNDLE))
end
