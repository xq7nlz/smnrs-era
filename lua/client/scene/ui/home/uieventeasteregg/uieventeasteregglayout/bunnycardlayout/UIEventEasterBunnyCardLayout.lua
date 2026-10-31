require "lua.client.scene.ui.home.uiEventNewYear.uiEventLayout.card.CardConfigView"

--- @class UIEventEasterBunnyCardLayout : UIEventEasterEggLayout
UIEventEasterBunnyCardLayout = Class(UIEventEasterBunnyCardLayout, UIEventEasterEggLayout)

--- @param view UIEventEasterEggView
--- @param eventTimeType EventTimeType
--- @param anchor UnityEngine_RectTransform
function UIEventEasterBunnyCardLayout:Ctor(view, eventTimeType, anchor)
    --- @type UIEasterBunnyCardLayoutConfig
    self.layoutConfig = nil
    --- @type EventEasterEggModel
    self.eventModel = nil
    --- @type EasterBunnyCardProduct
    self.productConfig = nil
    --- @type ItemsTableView
    self.itemsTableView = nil
    --- @type EventActionType
    self.eventActionType = EventActionType.EASTER_BUNNY_CARD_PURCHASE
    --- @type SubscriptionPackCollectionInBound
    self.subscriptionPackCollectionData = nil
    UIEventEasterEggLayout.Ctor(self, view, eventTimeType, anchor)
end

function UIEventEasterBunnyCardLayout:InitLayoutConfig()
    local inst = PrefabLoadUtils.Instantiate("easter_bunny_card_layout", self.anchor)
    UIEventEasterEggLayout.InitLayoutConfig(self, inst)

    self.layoutConfig.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)

    self:InitLocalization()

    self:InitItemTableView()
end

function UIEventEasterBunnyCardLayout:InitItemTableView()
    self.itemsTableView = ItemsTableView(self.layoutConfig.rewardAnchor, nil, UIPoolType.RootIconView)
    self.cardConfig = CardConfigView(self.layoutConfig.cardCalculator)
end

function UIEventEasterBunnyCardLayout:InitLocalization()
    UIEventEasterEggLayout.InitLocalization(self)

    self.layoutConfig.textEventName.text = LanguageUtils.LocalizeCommon("event_easter_egg_bunny_tittle")
end

function UIEventEasterBunnyCardLayout:GetModelConfig()
    UIEventEasterEggLayout.GetModelConfig(self)
end

function UIEventEasterBunnyCardLayout:OnShow()
    UIEventEasterEggLayout.OnShow(self)
    self.dataId = self.eventModel.timeData.dataId
    self.subscriptionPackCollectionData = self.eventModel:GetSubscriptionDurationData(self.dataId)

    --- @type EasterBunnyCardStore
    self.bunnyCardStore = ResourceMgr.GetPurchaseConfig():GetEventEasterBunnyCardStore()
    local allPacks = self.bunnyCardStore:GetCurrentPack()
    self.productConfig = allPacks:GetAllPackBase():Get(1)

    self.layoutConfig.textEventDesc.text = string.format(LanguageUtils.LocalizeCommon("event_easter_egg_bunny_desc"), self.productConfig.durationInDays)

    self:SetPackKey()

    local subscriptionDurationDict = self.subscriptionPackCollectionData.subscriptionDurationDict
    if subscriptionDurationDict ~= nil
            and subscriptionDurationDict:IsContainKey(self.packId) then
        self.day = subscriptionDurationDict:Get(self.packId)
    else
        self.day = nil
    end

    local isBought = self.day ~= nil and self.day > 0
    self:SetInstantReward(self.productConfig.rewardNotInstantList, isBought)

    local vip = self.productConfig:GetVip()
    self:SetVipText(vip)

    self:ShowStatus()
end

function UIEventEasterBunnyCardLayout:SetPackKey()
    self.packId = self.productConfig.id
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.bunnyCardStore.opCode, self.packId, self.eventModel.timeData.dataId)
end

function UIEventEasterBunnyCardLayout:OnHide()
    UIEventEasterEggLayout.OnHide(self)
    self.itemsTableView:Hide()
end

function UIEventEasterBunnyCardLayout:ShowStatus()
    self.isUnlock = not self:CanBuy()
    self.layoutConfig.buttonBuy.gameObject:SetActive(not self.isUnlock)
    if not self.isUnlock then
        self.layoutConfig.textLimit.text = string.format(LanguageUtils.LocalizeCommon("limit_x"),
                string.format("%s/%s",
                        self.productConfig.stock - self.eventModel:GetNumberBuy(self.eventActionType, self.packId),
                        self.productConfig.stock))
        self.layoutConfig.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    else
        self.layoutConfig.textLimit.text = LanguageUtils.LocalizeCommon("purchased")
    end
    self:CheckShowCardViewTag(self.productConfig.rewardNotInstantList, self.isUnlock)
end

function UIEventEasterBunnyCardLayout:OnClickBuy()
    if not self.isUnlock then
        BuyUtils.InitListener(function()
            self:ShowStatus()
        end)
        RxMgr.purchaseProduct:Next(self.packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

function UIEventEasterBunnyCardLayout:SetInstantReward(rewardList, isBought)
    ---@type List
    local listIconData = List()
    ---@param v RewardInBound
    for i, v in ipairs(rewardList:GetItems()) do
        local iconData = v:GetIconData()
        if isBought == false then
            iconData.quantity = v:GetNumberBase()
        else
            iconData.quantity = v:GetNumber()
        end
        listIconData:Add(iconData)
    end
    self.itemsTableView:SetData(listIconData, UIPoolType.RootIconView)

    if self.cardConfigList == nil then
        self.cardConfigList = List()
        self.cardConfigList:Add(self.cardConfig)
        for i = 1, rewardList:Count() - 1 do
            local cardView = CardConfigView(U_GameObject.Instantiate(self.layoutConfig.cardCalculator.gameObject,
                    self.layoutConfig.transform))
            self.cardConfigList:Add(cardView)
        end
    end
end

function UIEventEasterBunnyCardLayout:CheckShowCardViewTag(rewardList, isBought)
    Coroutine.start(function()
        coroutine.waitforendofframe()
        for i = 1, rewardList:Count() do
            ---@type CardConfigView
            local card = self.cardConfigList:Get(i)
            ---@type RewardInBound
            local reward = rewardList:Get(i)
            local pos = self.itemsTableView:Get(i).config.transform.position
            pos.y = pos.y + 1
            local factorType = nil
            if isBought == false then
                factorType = reward:GetFACTOR_TYPE()
            end
            local calculationType = nil
            if isBought == false then
                calculationType = reward:GetCALCULATOR_TYPE()
            end
            card:ShowCard(pos, factorType, calculationType)
            card:EnableCard((reward:GetFACTOR_TYPE() ~= nil or reward:GetCALCULATOR_TYPE() ~= nil) and not isBought)
        end

        self.itemsTableView:ActiveMaskSelect(isBought)
    end)
end

function UIEventEasterBunnyCardLayout:CanBuy()
    local numberBought = self.eventModel:GetNumberBuy(self.eventActionType, self.packId)
    return (self.productConfig.stock - numberBought) > 0
end

function UIEventEasterBunnyCardLayout:SetVipText(vipText)
    self.layoutConfig.vipPointView:SetActive(vipText ~= nil)
    if vipText ~= nil then
        self.layoutConfig.vipText.text = "+" .. tostring(vipText)
    end
end