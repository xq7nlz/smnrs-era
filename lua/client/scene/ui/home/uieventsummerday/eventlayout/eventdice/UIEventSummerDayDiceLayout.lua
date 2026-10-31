require "lua.client.data.Event.EventHalloweenConfig"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.LapSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceRewardResult"

local TIME_TO_ROLL = 0.15
--- @class UIEventSummerDayDiceLayout : UIEventSummerDayLayout
UIEventSummerDayDiceLayout = Class(UIEventSummerDayDiceLayout, UIEventSummerDayLayout)

--- @param view UIEventHalloweenView
--- @param halloweenTab HalloweenTab
--- @param anchor UnityEngine_RectTransform
function UIEventSummerDayDiceLayout:Ctor(view, halloweenTab, anchor)
    ---@type UIEventHalloweenView
    self.view = view
    --- @type DiceLayoutConfig
    self.layoutConfig = nil
    ---@type List<DiceSlotView>
    self.diceList = nil
    ---@type List<LapSlotView>
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
    ---@type boolean
    self.rollAnimSkip = false
    ---@type EventDiceGameData
    self.eventDiceData = nil
    ---@type List
    self.reward = List()

    self.arrowTransform_1 = nil

    self.arrowTransform_2 = nil

    --- @type ItemsTableView
    self.moneyTableView = nil
    UIEventSummerDayLayout.Ctor(self, view, halloweenTab, anchor)
end

function UIEventSummerDayDiceLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("summer_day_dice_layout", self.anchor)
    UIEventSummerDayLayout.InitLayoutConfig(self, inst)
    self.arrowTransform_1 = self.layoutConfig.select1:GetChild(0)
    self.arrowTransform_2 = self.layoutConfig.select2:GetChild(0)
    self.rollAnim = self.layoutConfig.rollAnim
    self.bg = self.layoutConfig.rollBg
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitLocalization()
    self:GetModelConfig()
    self:InitDiceViews()
    self:InitLapViews()
    self:InitButtons()
    self.rollAnimSkip = false
    self.layoutConfig.iconTick.gameObject:SetActive(false)

    --self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventSummerDayDiceLayout:InitButtons()
    self.layoutConfig.rollButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll(false)
    end)
    self.layoutConfig.rollAllButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll(true)
    end)
    self.layoutConfig.checkboxSkip.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnTickSkip()
    end)
end

function UIEventSummerDayDiceLayout:InitDiceViews()
    if self.diceList == nil then
        self.diceList = List()
    end
    local dicList = self.eventConfig:GetDiceConfig()
    for i = 1, self.layoutConfig.diceRollContainer.childCount do
        if dicList:IsContainKey(i) then
            local reward = dicList:Get(i)
            local diceView = DiceSlotView(self.layoutConfig.diceRollContainer:GetChild(i - 1), i)
            diceView:SetReward(reward)
            self.diceList:Add(diceView)
        end
    end
end

function UIEventSummerDayDiceLayout:InitLapViews()
    if self.lapList == nil then
        self.lapList = List()
    end
    local dicList = self.eventConfig:GetLapConfig()
    for i = 1, self.layoutConfig.content.childCount do
        if dicList:IsContainKey(i) then
            ---@type EventHalloweenLapDataConfig
            local reward = dicList:Get(i)
            local lapView = LapSlotView(self.layoutConfig.content:GetChild(i - 1), i, reward:GetLapRequire())
            lapView:SetReward(reward:GetRewardList())
            self.lapList:Add(lapView)
        end
    end
end

function UIEventSummerDayDiceLayout:UpdateLapViews()
    local questId = self.eventConfig:GetQuestId(self.lapCompleted)
    self.layoutConfig.lapCompletedValue.text = self.lapCompleted
    --XDebug.Log(string.format("lap: %s, quest id: %s",self.lapCompleted, questId))
    for i = 1, self.lapList:Count() do
        local view = self.lapList:Get(i)
        view:SetView(questId)
    end
end

function UIEventSummerDayDiceLayout:UpdateDiceViews()
    for i = 1, self.diceList:Count() do
        --- @type DiceSlotView
        local view = self.diceList:Get(i)
        for j = 1, self.posList:Count() do
            local temp = self.posList:Get(j) + 1
            if i == temp then
                view:SetView(true)
                break
            end
        end
    end
end

function UIEventSummerDayDiceLayout:ResetLapViews()
    for i = 1, self.lapList:Count() do
        local view = self.lapList:Get(i)
        view:SetView(0)
    end
end

function UIEventSummerDayDiceLayout:ResetDiceViews(showEffect)
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

function UIEventSummerDayDiceLayout:InitLocalization()
    self.layoutConfig.startTitle.text = LanguageUtils.LocalizeCommon("start")
    local diceGuide = StringUtils.FormatLocalize(LanguageUtils.LocalizeCommon("summer_day_dice_guide"), nil, nil, LanguageUtils.LocalizeCommon("daily_packs"))
    self.layoutConfig.diceGuideTitle.text = diceGuide
    self.layoutConfig.localizeSkipAnim.text = LanguageUtils.LocalizeCommon("skip_dice_anim")
    self.layoutConfig.diceTitle.text = LanguageUtils.LocalizeCommon("summer_day_dice_title")
    self.layoutConfig.lapTitle.text = LanguageUtils.LocalizeCommon("lap_reward")
    self.layoutConfig.rollText.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.localizeLapCompleted.text = LanguageUtils.LocalizeCommon("completed")
    self.layoutConfig.rollAllText.text = LanguageUtils.LocalizeCommon("roll_all")
end

function UIEventSummerDayDiceLayout:SetUpLayout()
    UIEventLayout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
    self:ShowMoneyBar()
end

function UIEventSummerDayDiceLayout:OnShow()
    UIEventSummerDayLayout.OnShow(self)
    self:FillData()
    self:UpdateRequireView()
    self:UpdateRewardRoll()
    self:InitLapViews()
    --self.rollAnimSkip = false
    --self.layoutConfig.iconTick.gameObject:SetActive(false)
end

function UIEventSummerDayDiceLayout:ShowMoneyBar()
    self.moneyList = List()
    ---@type MoneyBarView
    local moneyBarView2 = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.moneyBarAnchor)
    moneyBarView2:SetIconData(MoneyType.EVENT_SUMMER_EXCHANGE_TICKET)
    moneyBarView2.config.buttonInfo.interactable = true
    moneyBarView2.config.buttonInfo.onClick:RemoveAllListeners()
    moneyBarView2:SetSize(0, 0)
    moneyBarView2.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        moneyBarView2:ShowInfo()
    end)
    self.moneyList:Add(moneyBarView2)
end

function UIEventSummerDayDiceLayout:ReturnPoolMoneyBar()
    ---@param v MoneyBarView
    for _, v in pairs(self.moneyList:GetItems()) do
        v:ReturnPool()
    end
    self.moneyList:Clear()
end

function UIEventSummerDayDiceLayout:FillData()
    self.diceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.diceBarAnchor)
    self.diceBarView:SetIconData(MoneyType.EVENT_SUMMER_PLAY_TICKET)
    self.diceBarView.config.buttonInfo.interactable = true
    self.diceBarView.config.buttonInfo.onClick:RemoveAllListeners()
    self.diceBarView:SetSize(0, 0)
    self.diceBarView.config.buttonInfo.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self.diceBarView:ShowInfo()
    end)
    self.eventDiceData = self.eventModel:GetDiceData()
    self.position = self.eventDiceData.position + 1
    self.prevPosition = self.position
    self.lapCompleted = self.eventDiceData.lapCompleted
    self.rollNum = self.eventDiceData.rollNumber
    --- @type List
    self.posList = self.eventModel:GetPositionDiceList()
    if self.position ~= 1 then
        self.posList:Add(self.position - 1)
    end
    self:UpdateCurrentDiceView()
    self:UpdateLapViews()
    self:UpdateDiceViews()
end

--- @return DiceSlotView
function UIEventSummerDayDiceLayout:UpdateCurrentDiceView()
    if self.position <= self.diceList:Count() then
        local view = self.diceList:Get(self.position)
        local check = self:IsBigDice(self.position)
        self:SetEnableArrow(check, true)
        self:SetEnableFrame(view.config.transform.position, check, true)
        return view
    end
    return nil
end

function UIEventSummerDayDiceLayout:UpdateRequireView()
    if self.requireList == nil then
        self.requireList = self.eventConfig:GetRollRequireConfig()
    end
    self.layoutConfig.requireText.text = self.requireList:Get(1).number
end

function UIEventSummerDayDiceLayout:UpdateRewardRoll()
    self.rewardList = self.eventConfig:GetRollRewardConfig()
    self.layoutConfig.fxText.text = string.format("%s %s", "+", self.rewardList:Get(1).number)
end

function UIEventSummerDayDiceLayout:StartAnimRollDice(isAll)
    self.bg.color = U_Color(0, 0, 0, 0)
    self.bg.gameObject:SetActive(true)
    self.bg:DOColor(U_Color(0, 0, 0, 0.75), 1)

    if self.rollAnimSkip == false then
        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_ROLL)
        self.rollAnim.gameObject:SetActive(true)
        self.rollAnim.AnimationState:SetAnimation(0, "roll", true)
    end
end

function UIEventSummerDayDiceLayout:OnTickSkip()
    self.rollAnimSkip = not self.rollAnimSkip
    self.layoutConfig.iconTick.gameObject:SetActive(self.rollAnimSkip)
end
function UIEventSummerDayDiceLayout:OnClickRoll(isAll)
    local onReceived = function(result)
        --- @type DiceRewardResult
        local diceResult

        local onBufferReading = function(buffer)
            diceResult = DiceRewardResult(buffer)
            self.eventModel.eventDiceGameData = diceResult.eventDiceGameData
        end

        local onSuccess = function()
            if diceResult ~= nil then
                if isAll == false then
                    local fxRollStartPos = self.layoutConfig.fxRoll.transform.localPosition
                    ---@type UnityEngine_Vector3
                    local fxRollPos = fxRollStartPos
                    self.coroutine = Coroutine.start(function()
                        self.layoutConfig.fxRoll.gameObject:SetActive(true)
                        while true do
                            coroutine.waitforendofframe()
                            if fxRollPos.y >= 75 then
                                fxRollStartPos.y = 0
                                self.layoutConfig.fxRoll.transform.localPosition = fxRollStartPos
                                self.layoutConfig.fxRoll.gameObject:SetActive(false)
                                break
                            else
                                fxRollPos.y = fxRollPos.y + 2
                                self.layoutConfig.fxRoll.transform.localPosition = fxRollPos
                            end
                        end
                    end)
                end

                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_ROLL)

                self.reward = diceResult.rewards
                self.touch = TouchUtils.Spawn("DiceRollAnimation")
                self.prevPosition = self.position
                self.position = diceResult.newPosition + 1
                self.diceValue = diceResult.diceValue
                self.eventDiceData.position = diceResult.newPosition
                self.posList:Add(self.eventDiceData.position)
                Coroutine.start(function()
                    if isAll == false then
                        if self.rollAnimSkip ~= true then
                            coroutine.waitforseconds(2)
                        end
                        ---@type UnityEngine_UI_Image
                        local rollImage = self.layoutConfig.rollImage
                        rollImage.sprite = ResourceLoadUtils.LoadIconRollDice(self.diceValue)
                        rollImage.color = U_Color(1, 1, 1, 1)
                        self.rollAnim.gameObject:SetActive(false)
                        rollImage.gameObject:SetActive(true)
                        zg.audioMgr:PlaySfxUi(SfxUiType.DICE_END)
                        --rollImage:DOColor(U_Color(1,1,1,1), 0.2)
                        coroutine.waitforseconds(0.5)
                        self.bg:DOColor(U_Color(0, 0, 0, 0), 1)
                        coroutine.waitforseconds(0.5)
                        rollImage:DOColor(U_Color(1, 1, 1, 0), 0.5)
                        coroutine.waitforseconds(0.5)
                        rollImage.gameObject:SetActive(false)
                        self.bg.gameObject:SetActive(false)
                    end

                    self:DiceRollAnimation(isAll, diceResult)

                    local numberRoll = 1
                    if isAll then
                        numberRoll = InventoryUtils.GetMoney(MoneyType.EVENT_SUMMER_PLAY_TICKET)
                    end

                    InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_SUMMER_PLAY_TICKET, numberRoll)
                    self.view:CheckAllNotificationTab()
                end)
            end
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end

    local canBuy = InventoryUtils.IsEnoughSingleResourceRequirement(self.requireList:Get(1))
    if canBuy then
        if isAll == true then
            local yesCallback = function()
                self:RequestRoll(onReceived, isAll)
            end
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_roll_dice"), nil, yesCallback, nil)
        else
            self:RequestRoll(onReceived, isAll)
        end
    end
end

function UIEventSummerDayDiceLayout:RequestRoll(onReceived, isAll)
    if self.rollAnimSkip == false and isAll == false then
        self:StartAnimRollDice()
    end
    local outBound = UnknownOutBound.CreateInstance(PutMethod.Bool, isAll)
    NetworkUtils.Request(OpCode.EVENT_SUMMER_DAY_DICE_ROLL, outBound, onReceived)
end
--- @param diceResult DiceRewardResult
function UIEventSummerDayDiceLayout:DiceRollAnimation(isALl, diceResult)
    Coroutine.start(function()
        if isALl == false then
            ---@type DiceSlotView
            local diceView = nil
            if self.position > self.diceList:Count() then
                self.position = self.diceList:Count()
            end

            local temp = self.prevPosition + self.diceValue
            if temp > self.diceList:Count() then
                self.lapCompleted = self.lapCompleted + 1
                self.eventDiceData.lapCompleted = self.eventDiceData.lapCompleted + 1
                for i = self.prevPosition + 1, self.diceList:Count() do
                    diceView = self.diceList:Get(i)
                    local check = self:IsBigDice(i)
                    self:SetEnableArrow(check, false)
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    self:SetEnableFrame(diceView.config.transform.position, check, true)
                    coroutine.waitforseconds(TIME_TO_ROLL)
                    self:SetEnableFrame(diceView.config.transform.position, check, false)
                end
                local check_2 = self:IsBigDice(1)
                diceView = self.diceList:Get(1)
                self:SetEnableArrow(check_2, false)
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                self:SetEnableFrame(diceView.config.transform.position, check_2, true)
                coroutine.waitforseconds(TIME_TO_ROLL)
                if diceView ~= nil then
                    self:SetEnableArrow(check_2, true)
                    self.prevPosition = self.position
                    if self.position ~= 1 then
                        --diceView:ShowRewardInbound()
                        --if self.reward ~= nil then
                        --    PopupUtils.ClaimAndShowRewardList(self.reward)
                        --end
                    end
                end
                self:UpdateLapViews()
                coroutine.waitforseconds(TIME_TO_ROLL + 0.5)
                self:ResetSelect(false)
                --diceView:SetView(true)
                coroutine.waitforseconds(0.25)
                local count
                local _diceView = nil
                if self.rollAnimSkip == false then
                    count = 2
                    for j = 1, count do
                        for i = 1, self.diceList:Count() do
                            --- @type DiceSlotView
                            _diceView = self.diceList:Get(i)
                            zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                            _diceView:SetEnableFrame(true)
                            coroutine.waitforseconds(0.035)
                            _diceView:SetEnableFrame(false)
                        end
                    end
                end
                if self.rollAnimSkip == false then
                    count = 3
                else
                    count = 0
                end
                for j = 1, count do
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    for i = 1, self.diceList:Count() do
                        --- @type DiceSlotView
                        _diceView = self.diceList:Get(i)
                        _diceView:SetEnableFrame(true)
                    end
                    coroutine.waitforseconds(0.6)
                end

                coroutine.waitforseconds(0.2)
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                self:ResetDiceViews(true)
                coroutine.waitforseconds(0.2)
                local view = self:UpdateCurrentDiceView()
                view:SetView(true)
                --view:ShowRewardInbound()
                if self.reward ~= nil then
                    PopupUtils.ClaimAndShowRewardList(self.reward)
                end
                self.posList:Clear()
                self.posList:Add(self.eventDiceData.position)
            else
                ---@type DiceSlotView
                local check = false
                for i = self.prevPosition + 1, self.position do
                    check = self:IsBigDice(i)
                    diceView = self.diceList:Get(i)
                    self:SetEnableArrow(check, false)
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    self:SetEnableFrame(diceView.config.transform.position, check, true)
                    coroutine.waitforseconds(TIME_TO_ROLL)
                    self:SetEnableFrame(diceView.config.transform.position, check, false)
                end
                if diceView ~= nil then
                    zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                    self:SetEnableArrow(check, true)
                    self:SetEnableFrame(diceView.config.transform.position, check, true)
                    self.prevPosition = self.position
                    --diceView:ShowRewardInbound()
                    if self.reward ~= nil then
                        PopupUtils.ClaimAndShowRewardList(self.reward)
                    end
                    diceView:SetView(true)
                end
            end
        else
            self.lapCompleted = diceResult.eventDiceGameData.lapCompleted
            --- @type List
            self.posList:Clear()
            self.posList = diceResult.eventDiceGameData.historyPositionList
            if self.position ~= 1 then
                self.posList:Add(self.position - 1)
            end
            self:ResetDiceViews(true)
            self:UpdateCurrentDiceView()
            self:UpdateLapViews()
            self:UpdateDiceViews()
            if self.reward ~= nil then
                PopupUtils.ClaimAndShowRewardList(self.reward)
            end
        end
        self.touch:Enable()
    end)
end

function UIEventSummerDayDiceLayout:IsBigDice(index)
    local indexList = { 1, 10, 14, 23 }
    for i, v in ipairs(indexList) do
        if v == index then
            return true
        end
    end
    return false
end
function UIEventSummerDayDiceLayout:SetEnableArrow(check, isEnable)
    if check then
        self.arrowTransform_1.gameObject:SetActive(isEnable)
        self.arrowTransform_2.gameObject:SetActive(not isEnable)
    else
        self.arrowTransform_1.gameObject:SetActive(not isEnable)
        self.arrowTransform_2.gameObject:SetActive(isEnable)
    end
end
function UIEventSummerDayDiceLayout:SetEnableFrame(position, check, isEnable)
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
function UIEventSummerDayDiceLayout:ResetSelect(isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
    self.layoutConfig.select2.gameObject:SetActive(isEnable)
end
function UIEventSummerDayDiceLayout:OnHide()
    self:ResetDiceViews()
    self:ResetLapViews()
    self:UpdateCurrentDiceView()
    if self.diceBarView ~= nil then
        self.diceBarView:ReturnPool()
        self.diceBarView = nil
    end
    self:ReturnPoolMoneyBar()
    --self.moneyTableView:Hide()
    --if self.eventDiceData ~= nil then
    --    self.eventDiceData = nil
    --    XDebug.Log("dice data onhide: " .. tostring(self.eventModel:GetDiceData()))
    --end
end

