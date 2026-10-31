--- @class UIPopupBuyLevelBattlePassView : UIBaseView
UIPopupBuyLevelBattlePassView = Class(UIPopupBuyLevelBattlePassView, UIBaseView)

--- @param model UIPopupBuyLevelBattlePassModel
function UIPopupBuyLevelBattlePassView:Ctor(model)
    --- @type UIPopupBuyLevelBattlePassConfig
    self.config = nil
    ---@type ItemIconView
    self.itemView = nil
    ---@type InputNumberView
    self.inputView = nil
    ---@type MoneyBarLocalView
    self.moneyBarView = nil
    ---@type PopupBuyItemData
    self.popupBuyItemData = nil
    --- @type UILoopScroll
    self.scrollReward = nil
    --- @type number
    self.priceTotal = 0
    --- @type List
    self.listItemGain = nil
    UIBaseView.Ctor(self, model)
    --- @type UIPopupBuyLevelBattlePassModel
    self.model = model
end

function UIPopupBuyLevelBattlePassView:OnReadyCreate()
    self.config = UIBaseConfig(self.uiTransform)

    self.moneyBarView = MoneyBarLocalView(self.config.moneyBar)

    self:InitButtons()

    self:InitScroll()

    self:InitData()
end

function UIPopupBuyLevelBattlePassView:InitData()
    self.popupBuyItemData = PopupBuyItemData()
    self.popupBuyItemData.number = 1
    self.popupBuyItemData.minInput = 1
    self.popupBuyItemData.maxInput = 10
end

function UIPopupBuyLevelBattlePassView:InitButtons()
    self.config.bgClose.onClick:AddListener(function()
        self:OnClickBackOrClose()
    end)
    self.config.buttonPurchase.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
    self.config.buttonHelp.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickHelp()
    end)
end

function UIPopupBuyLevelBattlePassView:InitScroll()
    --- @param obj RootIconView
    local onCreateItem = function(obj, index)
        index = index + 1
        --- @type ItemIconData
        local reward = self.listItemGain:Get(index)
        obj:SetIconData(reward)
        obj:RegisterShowInfo()
    end
    self.scrollReward = UILoopScroll(self.config.scrollReward, UIPoolType.RootIconView, onCreateItem)
end

function UIPopupBuyLevelBattlePassView:InitLocalization()
    self.config.textTitle.text = LanguageUtils.LocalizeCommon("battle_pass_purchase_level")
end

--- @param data {onBuySuccess : function}
function UIPopupBuyLevelBattlePassView:OnReadyShow(data)
    zg.audioMgr:PlaySfxUi(SfxUiType.POPUP_OPEN)
    self.onBuySuccess = data.onBuySuccess

    --- @type EventBattlePassModel
    self.eventBattlePassModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BATTLE_PASS)
    --- @type EventBattlePassConfig
    local eventBattlePassConfig = self.eventBattlePassModel:GetConfig()
    if eventBattlePassConfig then
        --- @type ExchangeEventConfig
        self.exchangeExpConfig = eventBattlePassConfig:GetExchangeExpConfig()
    end
    self.popupBuyItemData.maxInput = self.exchangeExpConfig.limit -
            self.eventBattlePassModel:GetNumberBuy(EventActionType.BATTLE_PASS_EXCHANGE_EXP, self.exchangeExpConfig.id)


    ---@type EventBattlePassConfig
    local eventConfig = self.eventBattlePassModel:GetConfig()
    ---@type List
    self.listLineReward = eventConfig:GetLineRewardConfig()


    self:UpdateIconPrice(self.exchangeExpConfig.itemIconData)

    self:ShowInputBuy()
end

function UIPopupBuyLevelBattlePassView:ShowInputBuy()
    if self.inputView == nil then
        self.inputView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.InputNumberView, self.config.inputNumber)

        self.inputView.onChangeInput = function(value)
            self:OnChangeInput(value)
        end
    end

    self.inputView:SetData(1, self.popupBuyItemData.minInput, self.popupBuyItemData.maxInput)
end

function UIPopupBuyLevelBattlePassView:OnChangeInput(value)
    self.popupBuyItemData.number = value

    self:UpdateStatus(value)

    self:UpdateListReward(value)
end

function UIPopupBuyLevelBattlePassView:UpdateStatus(value)
    self.config.textPrice.text = self.exchangeExpConfig.itemIconData.quantity * value
    local color = UIUtils.green_normal
    --self.config.textLimit.text = string.format(UIUtils.SetColorString(UIUtils.brown, LanguageUtils.LocalizeCommon("limit_x")),string.format("%s/%s",    UIUtils.SetColorString(UIUtils.green_normal, value),     UIUtils.SetColorString(UIUtils.green_normal,self.popupBuyItemData.maxInput)))

    self.config.textLimit.text = string.format( LanguageUtils.LocalizeCommon("limit_x"), string.format("<color=#%s>%s/%s</color>", color, value, self.popupBuyItemData.maxInput))
    -- self.config.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
           -- string.format("%s/%s", value, self.popupBuyItemData.maxInput))
end

function UIPopupBuyLevelBattlePassView:UpdateListReward(value)
    self.listItemGain = List()

    local gainExp = 0
    --- @param v ItemIconData
    for k, v in pairs(self.exchangeExpConfig.listRewardItem:GetItems()) do
        local reward = v:Clone()
        reward.quantity = reward.quantity * value
        --self.listItemGain:Add(reward)
        if reward.type == ResourceType.Money and reward.itemId == MoneyType.BATTLE_PASS_EXP then
            gainExp = reward.quantity
        end
    end

    local currentExp = self.eventBattlePassModel:GetExp()
    local nextLevel =self.eventBattlePassModel:GetLevelByExp(currentExp + gainExp).level
    local currentLevel = self.eventBattlePassModel:GetLevelByExp(currentExp).level
    for i =  currentLevel+1, nextLevel do
        ---@type LineRewardConfig
        local item = self.listLineReward:Get(i)
        if item.isFree == nil then
            if self.eventBattlePassModel.isPurchasedPremium then
                self.listItemGain:Add(item.reward:GetIconData())
            end
        else
            self.listItemGain:Add(item.reward:GetIconData())
        end
    end

    self.scrollReward:Resize(self.listItemGain:Count())

    self.config.textLevelChange.text = string.format("%s %s      %s %s",
            LanguageUtils.LocalizeCommon("level"),
            currentLevel,
            UIUtils.SetColorString(UIUtils.green_dark,LanguageUtils.LocalizeCommon("level")),
            UIUtils.SetColorString(UIUtils.green_dark, nextLevel))
    self.config.textBuy.text = LanguageUtils.LocalizeCommon("buy");
end

function UIPopupBuyLevelBattlePassView:Hide()
    UIBaseView.Hide(self)
    if self.inputView ~= nil then
        self.inputView:ReturnPool()
        self.inputView = nil
    end
    if self.moneyBarView ~= nil then
        self.moneyBarView:RemoveListener()
    end
    self.scrollReward:Hide()
end

function UIPopupBuyLevelBattlePassView:OnClickBuy()
    local price = self.exchangeExpConfig.itemIconData
    local number = self.popupBuyItemData.number
    local canPurchase = InventoryUtils.IsEnoughSingleResourceRequirement(
            RewardInBound.CreateBySingleParam(price.type, price.itemId, price.quantity * number))
    if canPurchase then
        local onConfirmBuy = function()
            local rewardList
            --- @param buffer UnifiedNetwork_ByteBuf
            local onBufferReading = function(buffer)
                rewardList = NetworkUtils.GetListDataInBound(buffer, RewardInBound.CreateByBuffer)
            end
            local onSuccess = function()
                PopupUtils.ClaimAndShowRewardList(rewardList)
                InventoryUtils.Sub(price.type, price.itemId, price.quantity * number)
                self.eventBattlePassModel:AddNumberBuy(EventActionType.BATTLE_PASS_EXCHANGE_EXP, self.exchangeExpConfig.id, number)

                self:OnReadyHide()

                if self.onBuySuccess then
                    self.onBuySuccess()
                end
            end
            NetworkUtils.RequestAndCallback(OpCode.EVENT_BATTLE_PASS_EXCHANGE_EXP,
                    UnknownOutBound.CreateInstance(PutMethod.Int, self.exchangeExpConfig.id, PutMethod.Int, number),
                    onSuccess, SmartPoolUtils.LogicCodeNotification, onBufferReading)
        end
        PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("want_to_buy"), nil, onConfirmBuy)
    end
end

function UIPopupBuyLevelBattlePassView:OnClickHelp()
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, LanguageUtils.LocalizeHelpInfo("purchase_battle_pass_level_info"))
end

--- @param moneyIconData ItemIconData
function UIPopupBuyLevelBattlePassView:UpdateIconPrice(moneyIconData)
    self.config.iconPrice.sprite = ResourceLoadUtils.LoadMoneyIcon(moneyIconData.itemId)
    self.config.iconPrice:SetNativeSize()

    self.moneyBarView:SetIconData(moneyIconData.itemId, true, true, false)
end