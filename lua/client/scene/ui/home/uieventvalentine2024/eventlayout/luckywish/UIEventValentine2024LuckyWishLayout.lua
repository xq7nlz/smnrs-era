require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceSlotView"
require "lua.client.scene.ui.home.uiEventHalloween.uiEventHalloweenLayout.EventDice.DiceRewardResult"
require "lua.client.scene.ui.home.uiEventNewYear2023.EventLayout.luckyWish.LuckyWishResult"

local TIME_TO_ROLL = 0.15

--- @class UIEventValentine2024LuckyWishLayout : UIEventValentine2024Layout
UIEventValentine2024LuckyWishLayout = Class(UIEventValentine2024LuckyWishLayout, UIEventValentine2024Layout)

function UIEventValentine2024LuckyWishLayout:Ctor(view, tab, anchor)
    --- @type Valentine2024LuckyWishLayoutConfig
    self.layoutConfig = nil
    ---@type List<DiceSlotView>
    self.diceList = nil
    --- @type UILoopScroll
    self.uiScroll = nil
    ---@type boolean
    self.skipAnimation = false
    ---@type EventDiceGameData
    self.eventDiceData = nil

    self.arrowTransform_1 = nil

    self.arrowTransform_2 = nil

    --- @type List
    self.listQuestFeedBeast = nil

    UIEventValentine2024Layout.Ctor(self, view, tab, anchor)

    self.moneyTypeShow = MoneyType.EVENT_VALENTINE_LOTTERY_TICKET

    self.posMarked = List()
end

function UIEventValentine2024LuckyWishLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_2024_lucky_wish_layout", self.anchor)
    UIEventValentine2024Layout.InitLayoutConfig(self, inst)
    self.arrowTransform_1 = self.layoutConfig.select1:GetChild(0)
    --self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor)
    self:InitLocalization()
    self:GetModelConfig()
    self:InitDiceViews()
    self:InitButtons()
    self:InitScroll()
    self.listQuestWish = self.eventConfig:GetListWishQuestConfig()
end

function UIEventValentine2024LuckyWishLayout:InitButtons()
    self.layoutConfig.rollButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll(false)
    end)
    self.layoutConfig.rollAllButton.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickRoll(true)
    end)
    self.layoutConfig.buttonReset.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnResetLottery()
    end)
    self.layoutConfig.toggle.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickCheckbox()
    end)
end

function UIEventValentine2024LuckyWishLayout:OnClickCheckbox()
    self.skipAnimation = not self.skipAnimation
    self:InitTickEnableAnimation()
end

function UIEventValentine2024LuckyWishLayout:InitTickEnableAnimation()
    self.layoutConfig.iconTick.gameObject:SetActive(self.skipAnimation)
end

function UIEventValentine2024LuckyWishLayout:InitScroll()
    --- @param obj WishRewardItem
    local onCreateItem = function(obj, index)
        local dataIndex = index + 1
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestWish:Get(dataIndex)
        local level = questElementConfig:GetMainRequirementTarget()
        obj:SetData(level, questElementConfig:GetListReward())
        obj:SetClaim(level <= self.eventModel.wishTotal)
        obj:Highlight(dataIndex == self:_GetCurrentRewardMilestone())
    end
    self.uiScroll = UILoopScroll(self.layoutConfig.scrollReward, UIPoolType.WishRewardItem, onCreateItem)
end

function UIEventValentine2024LuckyWishLayout:_GetCurrentRewardMilestone()
    for i = 1, self.listQuestWish:Count() do
        --- @type QuestElementConfig
        local questElementConfig = self.listQuestWish:Get(i)
        local level = questElementConfig:GetMainRequirementTarget()
        if level > self.eventModel.wishTotal then
            return i
        end
    end
    return self.listQuestWish:Count()
end

function UIEventValentine2024LuckyWishLayout:InitDiceViews()
    if self.diceList == nil then
        self.diceList = List()
    end
    local effectScale = U_Vector3(0.365, 0.365, 0.365)
    local frameScale = U_Vector3(0.73, 0.73, 0.73)
    local dicList = self.eventConfig:GetLuckyWishData()
    for i = 1, self.layoutConfig.diceRollContainer.childCount do
        local reward = dicList:Get(i)
        local diceView = DiceSlotView(self.layoutConfig.diceRollContainer:GetChild(i - 1), i)
        diceView:SetReward(reward)
        diceView:IsEnableBg(false)
        diceView:SetScale(effectScale, frameScale)
        self.diceList:Add(diceView)
    end
end

function UIEventValentine2024LuckyWishLayout:UpdateDiceViews()
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

function UIEventValentine2024LuckyWishLayout:IsInPosList(index)
    for j = 1, self.posList:Count() do
        local temp = self.posList:Get(j)
        if index == temp then
            return true
        end
    end
    return false
end

function UIEventValentine2024LuckyWishLayout:ResetDiceViews(showEffect)
    for i = 1, self.diceList:Count() do
        local view = self.diceList:Get(i)
        view:SetView(false)
        if showEffect ~= nil then
            view:ShowEffect()
        end
    end
    self.first = nil
end

function UIEventValentine2024LuckyWishLayout:InitLocalization()
    self.layoutConfig.diceTitle.text = LanguageUtils.LocalizeCommon("event_lottery_valentine_title")
    self.layoutConfig.rollText.text = LanguageUtils.LocalizeCommon("roll")
    self.layoutConfig.rollAllText.text = LanguageUtils.LocalizeCommon("roll_all")
    self.layoutConfig.textReward.text = LanguageUtils.LocalizeCommon("reward")
    self.layoutConfig.textChanceReset.text = LanguageUtils.LocalizeCommon("text_chance_reset")
end

function UIEventValentine2024LuckyWishLayout:SetUpLayout()
    UIEventValentine2024Layout.SetUpLayout(self)
    self.anchor.gameObject:SetActive(true)
end
function UIEventValentine2024LuckyWishLayout:OnShow()
    UIEventValentine2024Layout.OnShow(self)
    self:FillData()
    self:UpdateRequireView()
    if self.eventModel.wishTotal >= self.listQuestWish:Get(self.listQuestWish:Count()):GetMainRequirementTarget() - 100 then
        self.uiScroll:Resize(self.listQuestWish:Count(), 4)
    else
        self.uiScroll:Resize(self.listQuestWish:Count(), math.max(0, self:_GetCurrentRewardMilestone() - 3))
    end
end

function UIEventValentine2024LuckyWishLayout:FillData()
    --- @type MoneyBarView
    self.diceBarView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyBarView, self.layoutConfig.diceBarAnchor)
    self.diceBarView:SetIconData(self.moneyTypeShow)
    self.diceBarView:AddListener(function()
        self:OnClickMoneyBar()
    end)

    self.posList = self.eventModel:GetOpenedLottery()

    self:UpdateDiceViews()
    --self:UpdatePosMarked()
end

function UIEventValentine2024LuckyWishLayout:UpdatePosMarked()
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

function UIEventValentine2024LuckyWishLayout:UpdateRequireView()
    if self.require == nil then
        self.require = self.eventConfig:GetWishConfig().require
    end
    self.layoutConfig.requireText.text = self.require.number

    if self.eventModel.listPosition:Count() == 8 then
        self.layoutConfig.buttonReset.gameObject:SetActive(false)
        self.layoutConfig.rollButton.gameObject:SetActive(true)
    else
        self.layoutConfig.buttonReset.gameObject:SetActive(false)
        self.layoutConfig.rollButton.gameObject:SetActive(true)
    end
    self.layoutConfig.textChanceResetValue.text = string.format("%s/%s", self.posList:Count(),
            self.eventConfig:GetWishConfig().resetConfig)
end

function UIEventValentine2024LuckyWishLayout:OnResetLottery()
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
        self.posList:Clear()
        self:UpdateRequireView()
        self.layoutConfig.buttonReset.gameObject:SetActive(false)
        self.layoutConfig.rollButton.gameObject:SetActive(true)
        self.touch:Enable()
    end)
end

function UIEventValentine2024LuckyWishLayout:ResetDiceViews(showEffect)
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

function UIEventValentine2024LuckyWishLayout:OnClickRoll(isAll)
    local onReceived = function(result)
        --- @type LotteryResult
        local diceResult
        local onBufferReading = function(buffer)
            diceResult = LuckyWishResult(buffer)
        end
        local onSuccess = function()
            self.touch = TouchUtils.Spawn("LotteryOnClickRoll")
            self.view:UpdateNotificationByTab(Valentine2024Tab.LUCKY_WISH)
            Coroutine.start(function()
                ---@type DiceSlotView
                local diceView = nil
                if isAll == false and self.skipAnimation == false then
                    self.index = 0
                    self:SetEnableArrow(false)
                    self.prev = -1
                    local rollCount = 15
                    local time = 0.03 * (self.posList:Count() / 5 + 1)

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
                end

                coroutine.waitforseconds(0.05)
                zg.audioMgr:PlaySfxUi(SfxUiType.DICE_BEEP)
                --- this index load from server data
                local index = diceResult.listPosition:Get(diceResult.listPosition:Count())
                diceView = self.diceList:Get(index)
                diceView:SetView(true)

                --diceView:ShowRewardInbound()
                local pos = diceView.config.transform.position
                self:SetEnableFrame(pos, true)
                self:SetEnableArrow(true)
                if diceResult.rewards ~= nil then
                    PopupUtils.ClaimAndShowRewardList(diceResult.rewards)
                    diceResult.rewards = nil
                end

                local numberWish = self.require.number
                if isAll then
                    numberWish = InventoryUtils.GetMoney(MoneyType.EVENT_VALENTINE_LOTTERY_TICKET)
                end
                self.eventModel.wishTotal = self.eventModel.wishTotal + numberWish
                InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_VALENTINE_LOTTERY_TICKET, numberWish)
                self.eventModel.listPosition = diceResult.listPosition
                self.posList = self.eventModel.listPosition
                if isAll then
                    self:ResetDiceViews()
                end
                self:UpdateDiceViews()
                self:UpdateRequireView()

                if self.posList:Count() == 8 then
                    coroutine.waitforseconds(0.5)
                    self:ResetDiceViews(true)
                    self.posList:Clear()
                    self:UpdateRequireView()
                    self:SetEnableFrame(pos, false)
                    self:SetEnableArrow(false)
                    coroutine.waitforseconds(0.5)
                end

                if self.eventModel.wishTotal >= self.listQuestWish:Get(self.listQuestWish:Count()):GetMainRequirementTarget() then
                    self.uiScroll:Resize(self.listQuestWish:Count(), 4)
                else
                    self.uiScroll:Resize(self.listQuestWish:Count(), math.max(0, self:_GetCurrentRewardMilestone() - 3))
                end
                self.touch:Enable()
            end)
        end
        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, SmartPoolUtils.LogicCodeNotification)
    end
    local canRoll = InventoryUtils.IsEnoughSingleResourceRequirement(self.require)
    if canRoll then
        local requestWish = function()
            local outBound = UnknownOutBound.CreateInstance(PutMethod.Bool, isAll)
            NetworkUtils.Request(OpCode.EVENT_VALENTINE_2024_WISH, outBound, onReceived)
        end

        if isAll == false then
            requestWish()
        else
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_wish_all"), nil, requestWish, nil)
        end
    end
end

function UIEventValentine2024LuckyWishLayout:SetEnableArrow(isEnable)
    self.arrowTransform_1.gameObject:SetActive(isEnable)
end

function UIEventValentine2024LuckyWishLayout:SetEnableFrame(position, isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
    if position ~= nil then
        self.layoutConfig.select1.position = position
    end
end

function UIEventValentine2024LuckyWishLayout:ResetSelect(isEnable)
    self.layoutConfig.select1.gameObject:SetActive(isEnable)
end

function UIEventValentine2024LuckyWishLayout:OnHide()
    self:ResetDiceViews()
    self:SetEnableArrow(false)
    self:SetEnableFrame(nil, false)
    if self.diceBarView ~= nil then
        self.diceBarView:ReturnPool()
        self.diceBarView = nil
    end
end

function UIEventValentine2024LuckyWishLayout:OnClickMoneyBar()
    self.view:SelectTab(self.model.listSubEvent:Get(Valentine2024Tab.SPECIAL_OFFER))
end
