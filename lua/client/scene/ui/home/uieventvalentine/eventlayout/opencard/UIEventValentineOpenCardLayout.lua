--- @class UIEventValentineOpenCardLayout : UIEventValentineLayout
UIEventValentineOpenCardLayout = Class(UIEventValentineOpenCardLayout, UIEventValentineLayout)

local countCard = 35

--- @param view UIEventValentineView
--- @param tab number
--- @param anchor UnityEngine_RectTransform
function UIEventValentineOpenCardLayout:Ctor(view, tab, anchor)
    --- @type RootIconView
    self.currentItem = nil
    ---@type UIEventValentineOpenCardConfig
    self.layoutConfig = nil
    ---@type List
    self.listCard = List()
    --- @type ItemsTableView
    self.moneyTableView = nil

    UIEventValentineLayout.Ctor(self, view, tab, anchor)
end

function UIEventValentineOpenCardLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("valentine_open_card", self.anchor)
    UIEventValentineLayout.InitLayoutConfig(self, inst)
    self:InitButtonListener()
    self:InitLocalization()
    self.moneyTableView = ItemsTableView(self.layoutConfig.moneyBarAnchor, nil, UIPoolType.MoneyBarView)
end

function UIEventValentineOpenCardLayout:InitLocalization()
    UIEventValentineLayout.InitLocalization(self)
    --self.layoutConfig.localizeEventName.text = LanguageUtils.LocalizeCommon("event_valentine_open_card_title")
    --self.layoutConfig.localizeEventContent.text = LanguageUtils.LocalizeCommon("event_valentine_open_card_desc")
end

function UIEventValentineOpenCardLayout:OnClickCardWish()
    zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
    if self.eventModel.valentineOpenCardData.reachedRound < self.eventConfig:GetOpenCardConfig().listRound:Count() then
        local lastCard = self.eventModel.valentineOpenCardData.wishCardSelected
        local data = {}
        data.valentineOpenCardData = self.eventModel.valentineOpenCardData
        data.eventValentineOpenCardConfig = self.eventConfig:GetOpenCardConfig()
        data.callbackSelect = function()
            if lastCard <= 0 then
                self:UpdateCardReward()
            end
            self:UpdateCardWish()
            self:CheckSoftTut()
        end
        PopupMgr.ShowPopup(UIPopupName.UISelectCardWishList, data)
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("max_round"))
    end
end

function UIEventValentineOpenCardLayout:UpdateCardWish()
    if self.eventModel.valentineOpenCardData.wishCardSelected > 0 then
        if self.currentItem == nil then
            self.currentItem = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.layoutConfig.item.transform)
        end
        local iconData = self.eventConfig:GetOpenCardConfig()
                             :GetListCardWishById(self.eventModel.valentineOpenCardData.wishCardSelected).reward:GetIconData()
        self.currentItem:SetIconData(iconData)
        self.currentItem:RemoveAllListeners()
        if self.eventModel.valentineOpenCardData.reachedRound >= self.eventConfig:GetOpenCardConfig().listRound:Count() then
            self.currentItem:ActiveMaskSelect(true)
        end
    else
        self:ReturnPoolCardWish()
    end
    self:UpdateRound()
end

function UIEventValentineOpenCardLayout:UpdateRound()
    local round = self.eventModel.valentineOpenCardData.reachedRound + 1
    if round <= self.eventConfig:GetOpenCardConfig().listRound:Count() then
        round = string.format("%s/%s", round, self.eventConfig:GetOpenCardConfig().listRound:Count())
        if self.eventModel.valentineOpenCardData.wishCardSelected > 0 then
            self.layoutConfig.round.text = string.format(LanguageUtils.LocalizeCommon("round_x_wishing_reward"), round)
        else
            self.layoutConfig.round.text = string.format(LanguageUtils.LocalizeCommon("select_wishing_reward_for_round"), round)
        end
    else
        self.layoutConfig.round.text = LanguageUtils.LocalizeCommon("max_round")
    end
end

function UIEventValentineOpenCardLayout:InitCardReward()
    --- @type ValentineOpenCardItemView
    local item = self.listCard:Get(1)
    item:HideItem()
    ---@param v EventValentineOpenCardItem
    for i, v in ipairs(self.eventConfig:GetOpenCardConfig().listCardRewardId:GetItems()) do
        --- @type ValentineOpenCardItemView
        local item = self.listCard:Get(i + 1)
        item:SetIconData(v.reward:GetIconData())
    end
end

function UIEventValentineOpenCardLayout:UpdateCardReward()
    for i = 1, countCard do
        --- @type ValentineOpenCardItemView
        local item = self.listCard:Get(i)
        local dataId = self.eventModel.valentineOpenCardData.cardPositionOpenMap:Get(i)
        if dataId ~= nil then
            local card = nil
            if dataId >= 1000 then
                card = self.eventConfig:GetOpenCardConfig():GetListCardWishById(dataId)
            else
                card = self.eventConfig:GetOpenCardConfig():GetListCardRewardById(dataId)
            end
            if card ~= nil then
                item:SetIconData(card.reward:GetIconData())
            else
                XDebug.Error("NIL card " .. dataId)
            end
        else
            item:HideItem()
        end
    end
end

function UIEventValentineOpenCardLayout:InitButtonListener()
    self.layoutConfig.item.onClick:RemoveAllListeners()
    self.layoutConfig.item.onClick:AddListener(function ()
        self:OnClickCardWish()
    end)
end

function UIEventValentineOpenCardLayout:OnShow()
    self.eventModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_VALENTINE)
    self.eventConfig = self.eventModel:GetConfig()

    --FIX DATA
    if self.eventModel.valentineOpenCardData.reachedRound >= self.eventConfig:GetOpenCardConfig().listRound:Count()
            and self.eventModel.valentineOpenCardData.wishCardSelected <= 0 then
        self.eventModel.valentineOpenCardData.wishCardSelected = self.eventModel.valentineOpenCardData.wishCardHistories
                :Get(self.eventModel.valentineOpenCardData.wishCardHistories:Count())
    end

    UIEventValentineLayout.OnShow(self)
    self:ReturnPoolCard()
    for i = 1, countCard do
        --- @type ValentineOpenCardItemView
        local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.ValentineOpenCardItemView, self.layoutConfig.content)
        item:AddListener(function ()
            self:OnClickOpenCard(i)
        end)
        self.listCard:Add(item)
    end
    if self.eventModel.valentineOpenCardData.reachedRound < 1 and self.eventModel.valentineOpenCardData.wishCardSelected <= 0 then
        self:InitCardReward()
    else
        self:UpdateCardReward()
    end
    self:UpdateCardWish()
    self:CheckSoftTut()
    self:UpdateLocalizePrice()
end

function UIEventValentineOpenCardLayout:UpdateLocalizePrice()
    local coinPrice = self.eventConfig:GetOpenCardConfig().coinPrice
    local gemPrice = self.eventConfig:GetOpenCardConfig().gemPrice
    self.layoutConfig.price.text = string.format(LanguageUtils.LocalizeCommon("price_open_card_x"),
            coinPrice)
    self.layoutConfig.image.sprite = ResourceLoadUtils.LoadMoneyIcon( MoneyType.EVENT_VALENTINE_LUCKY_COIN)
    if InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_VALENTINE_LUCKY_COIN) >= coinPrice then
        self.layoutConfig.price.text = string.format(LanguageUtils.LocalizeCommon("price_open_card_x"),
                coinPrice)
        self.layoutConfig.image.sprite = ResourceLoadUtils.LoadMoneyIcon( MoneyType.EVENT_VALENTINE_LUCKY_COIN)
    elseif InventoryUtils.Get(ResourceType.Money, MoneyType.GEM) >= gemPrice then
        self.layoutConfig.price.text = string.format(LanguageUtils.LocalizeCommon("price_open_card_x"),
                gemPrice)
        self.layoutConfig.image.sprite = ResourceLoadUtils.LoadMoneyIcon( MoneyType.GEM)
    end
end


function UIEventValentineOpenCardLayout:CheckSoftTut()
    self.layoutConfig.softTut:SetActive((UIBaseView.IsActiveTutorial() == false) and (zg.playerData.remoteConfig.softTutValentine == nil) and (self.eventModel.valentineOpenCardData.reachedRound < 1 and self.eventModel.valentineOpenCardData.wishCardSelected <= 0))
end

function UIEventValentineOpenCardLayout:SetUpLayout()
    UIEventValentineLayout.SetUpLayout(self)
    self:ShowMoneyBar()
end

function UIEventValentineOpenCardLayout:ShowMoneyBar()
    local moneyList = List()
    moneyList:Add(MoneyType.EVENT_VALENTINE_LUCKY_COIN)
    moneyList:Add(MoneyType.GEM)
    self.moneyTableView:SetData(moneyList)
end

function UIEventValentineOpenCardLayout:OnClickOpenCard(index)
    --- @type ValentineOpenCardItemView
    local item = self.listCard:Get(index)
    if item.itemView ~= nil then
        item.itemView:ShowInfo()
    else
        if self.eventModel.valentineOpenCardData:CheckCanOpenCard(index) == true then
            local moneyOpenCard = nil
            local price = self.eventConfig:GetOpenCardConfig().coinPrice
            if InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_VALENTINE_LUCKY_COIN) >= price then
                moneyOpenCard = false
            end
            if moneyOpenCard == nil then
                price = self.eventConfig:GetOpenCardConfig().gemPrice
                if InventoryUtils.Get(ResourceType.Money, MoneyType.GEM) >= price then
                    moneyOpenCard = true
                end
            end
            if moneyOpenCard ~= nil then
                local openCard = function()
                    local onReceived = function(result)
                        local idReward = nil
                        --- @param buffer UnifiedNetwork_ByteBuf
                        local onBufferReading = function(buffer)
                            idReward = buffer:GetInt()
                        end
                        local onSuccess = function()
                            if moneyOpenCard == true then
                                InventoryUtils.Sub(ResourceType.Money, MoneyType.GEM, price)
                            else
                                InventoryUtils.Sub(ResourceType.Money, MoneyType.EVENT_VALENTINE_LUCKY_COIN, price)
                            end
                            self:UpdateLocalizePrice()
                            self.view:UpdateNotificationByTab(self.valentineTab)
                            ---@type ItemIconData
                            local iconData = nil
                            if idReward >= 1000 then
                                iconData = self.eventConfig:GetOpenCardConfig():GetListCardWishById(idReward).reward:GetIconData()
                                self.eventModel.valentineOpenCardData.wishCardHistories:Add(idReward)
                                self.eventModel.valentineOpenCardData.reachedRound = self.eventModel.valentineOpenCardData.reachedRound + 1
                                if self.eventModel.valentineOpenCardData.reachedRound >= self.eventConfig:GetOpenCardConfig().listRound:Count() then
                                    self.currentItem:ActiveMaskSelect(true)
                                else
                                    self.eventModel.valentineOpenCardData.wishCardSelected = -1
                                    self:ReturnPoolCardWish()
                                end
                            else
                                iconData = self.eventConfig:GetOpenCardConfig():GetListCardRewardById(idReward).reward:GetIconData()
                                self.eventModel.valentineOpenCardData.cardPositionOpenMap:Add(index, idReward)
                            end
                            item:SetIconData(iconData)
                            item:ActiveEffectOpenCard(false)
                            item:ActiveEffectOpenCard(true)
                            zg.audioMgr:PlaySfxUi(SfxUiType.OPEN_CARD)
                            iconData:AddToInventory()
                            SmartPoolUtils.ShowReward1Item(iconData)
                            self:UpdateCardWish()
                        end
                        local onFailed = function(logicCode)
                            SmartPoolUtils.LogicCodeNotification(logicCode)
                        end
                        NetworkUtils.ExecuteResult(result, onBufferReading, onSuccess, onFailed)
                    end
                    NetworkUtils.Request(OpCode.EVENT_VALENTINE_CARD_OPEN, UnknownOutBound.CreateInstance(PutMethod.Int, index, PutMethod.Bool, moneyOpenCard), onReceived)
                end
                if moneyOpenCard == true then
                    PopupUtils.ShowPopupNotificationUseResource(MoneyType.GEM, price, function()
                        openCard()
                    end)
                else
                    openCard()
                end
            else
                InventoryUtils.IsEnoughSingleResourceRequirement(RewardInBound.CreateBySingleParam(ResourceType.Money,
                        MoneyType.EVENT_VALENTINE_LUCKY_COIN, self.eventConfig:GetOpenCardConfig().coinPrice))
            end
        end
    end
end

function UIEventValentineOpenCardLayout:ReturnPoolCard()
    ---@param v ValentineOpenCardItemView
    for i, v in ipairs(self.listCard:GetItems()) do
        v:ReturnPool()
    end
    self.listCard:Clear()
end

function UIEventValentineOpenCardLayout:ReturnPoolCardWish()
    if self.currentItem ~= nil then
        self.currentItem:ReturnPool()
        self.currentItem = nil
    end
end

function UIEventValentineOpenCardLayout:OnHide()
    UIEventValentineLayout.OnHide(self)
    self.moneyTableView:Hide()
    self:ReturnPoolCard()
end