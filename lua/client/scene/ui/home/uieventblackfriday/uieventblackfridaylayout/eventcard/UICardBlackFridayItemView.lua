require "lua.client.scene.ui.home.uiEventBlackFriday.uiEventBlackFridayLayout.EventCard.CardBlackFridayConfigView"
--- @class UICardBlackFridayItemView
UICardBlackFridayItemView = Class(UICardBlackFridayItemView)

--- @param transform UnityEngine_Transform
--- @param view UICardLayout
function UICardBlackFridayItemView:Ctor(transform, view)
    --- @type BlackFridayCardConfig
    self.config = UIBaseConfig(transform)
    --- @type number
    self.packId = nil
    --- @type number
    self.dataId = nil
    --- @type string
    self.packKey = nil
    --- @type OpCode
    self.opCode = nil
    --- @type ItemsTableView
    self.itemsTable = nil
    --- @type IapDataInBound
    self.iapDataInBound = nil
    --- @type EventBlackFridayModel
    self.eventBlackFridayModel = nil

    self.view = view
    self:InitButtonListener()
    self:InitItemTableView()
end

function UICardBlackFridayItemView:InitLocalization()
    self.config.contentText.text = LanguageUtils.LocalizeCommon("black_friday_card_content")
end

function UICardBlackFridayItemView:InitButtonListener()
    self.config.buttonBuy.onClick:AddListener(function()
        zg.audioMgr:PlaySfxUi(SfxUiType.SELECT)
        self:OnClickBuy()
    end)
end

function UICardBlackFridayItemView:InitItemTableView()
    self.itemsTable = ItemsTableView(self.config.resAnchor)
    self.cardConfig = CardBlackFridayConfigView(self.view.layoutConfig.cardConfig)
end

function UICardBlackFridayItemView:OnShow(packId, dataId)
    self.dataId = dataId
    self.packId = packId
    --XDebug.Log("self.packId " .. tostring(self.packId) .. " data id " .. tostring(self.dataId))
    ---@type EventBlackFridayCardProduct
    self.data = ResourceMgr.GetPurchaseConfig():GetBlackFridayCard():GetPack(self.dataId):GetPackBase(self.packId)

    self.opCode = self.data.opCode
    self.packKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, dataId)
    --- @type IapDataInBound
    self.iapDataInBound = zg.playerData:GetMethod(PlayerDataMethod.IAP)
    self.eventBlackFridayModel = zg.playerData:GetEvents():GetEvent(EventTimeType.EVENT_BLACK_FRIDAY)
    --- @type EventBlackFridayConfig
    self.eventConfig = self.eventBlackFridayModel:GetConfig()
    self:ShowPack()
    self:SetPrice()
    self:SetPrice()
end

function UICardBlackFridayItemView:ShowPack()
    LanguageUtils.CheckInitLocalize(self, UICardBlackFridayItemView.InitLocalization)
    ---- @type EventBlackFridayCardProduct
    local numberBought = self.eventBlackFridayModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_CARD_PURCHASE, self.packId)
    local left = self.data.stock

    left = self.data.stock - numberBought
    self:ShowTextBuy(left, self.data.stock)

    if self.eventBlackFridayModel.subscriptionDurationDict ~= nil and self.eventBlackFridayModel.subscriptionDurationDict:IsContainKey(self.packId) then
        self.day = self.eventBlackFridayModel.subscriptionDurationDict:Get(self.packId)
    end
    local isBought = self.day ~= nil and self.day > 0

    local vipText, rewardList, rewardStaticList, rewardCalculationList, rewardFactorCalculationList = self.data:GetVipAndRewardListWithCondition(isBought)

    self:SetInstantReward(rewardStaticList, rewardCalculationList, rewardFactorCalculationList, isBought)
    self:SetVipText(vipText)
end

function UICardBlackFridayItemView:SetPrice()
    self.config.textPrice.text = zg.iapMgr:GetLocalPrizeString(self.packKey)
    --  XDebug.Log("pack key: "..tostring(self.packKey))
end

function UICardBlackFridayItemView:SetInstantReward(rewardList, rewardCalculationList, rewardFactorCalculationList, isBought)


    local listIcons
    if (isBought) then
        listIcons = RewardInBound.GetItemIconDataList(rewardList)
    else
        listIcons = RewardInBound.GetItemIconDataListNotCalculateVipSummonLevel(self.data.rewardNotInstantList)
    end

    self.itemsTable:SetData(listIcons, UIPoolType.RootIconView)
    if self.cardConfigList == nil then
        self.cardConfigList = List()
        self.cardConfigList:Add(self.cardConfig)
        for i = 1, rewardCalculationList:Count() - 1 do
            local cardView = CardBlackFridayConfigView(U_GameObject.Instantiate(self.view.layoutConfig.cardConfig.gameObject, self.view.layoutConfig.cardAnchor))
            self.cardConfigList:Add(cardView)
        end
        Coroutine.start(function()
            coroutine.waitforendofframe()
            coroutine.waitforendofframe()
            for i = 1, rewardCalculationList:Count() do
                ---@type CardBlackFridayConfigView
                local card = self.cardConfigList:Get(i)
                --local factor = rewardCalculationList:Get(i)
                --- @type EventBlackFridayCardProduct
                local _data = ResourceMgr.GetPurchaseConfig():GetBlackFridayCard():GetPack(self.dataId):GetPackBase(self.packId)
                local rewardInBound = _data.rewardNotInstantList:Get(i)
                card:ShowCard(rewardInBound:GetFACTOR_TYPE(), rewardInBound:GetCALCULATOR_TYPE())
                --card:ShowCard(rewardFactorCalculationList:Get(i), rewardInBound:GetFACTOR_TYPE())
                -- card:ShowCard(rewardFactorCalculationList:Get(i), factor)
            end

            for i = 1, self.cardConfigList:Count() do
                ---@type CardBlackFridayConfigView
                local card = self.cardConfigList:Get(i)
                card.config.gameObject:SetActive(not isBought)
            end

            self.view.layoutConfig.cardAnchor.gameObject:SetActive(not isBought)

            return
        end)
    else
        for i = 1, self.cardConfigList:Count() do
            ---@type CardBlackFridayConfigView
            local card = self.cardConfigList:Get(i)
            card.config.gameObject:SetActive(not isBought)
        end

        self.view.layoutConfig.cardAnchor.gameObject:SetActive(not isBought)
    end
end

function UICardBlackFridayItemView:SetVipText(vipText)
    self.config.vipText.text = "+" .. tostring(vipText)
end

function UICardBlackFridayItemView:Hide()
    self.itemsTable:Hide()
    self.day = nil
end

function UICardBlackFridayItemView:OnClickBuy()
    if self:CanBuy() then
        local data = ResourceMgr.GetPurchaseConfig():GetBlackFridayCard():GetPack(self.dataId):GetPackBase(self.packId)
        local packKey = self.packKey
        if data ~= nil then
            packKey = ClientConfigUtils.GetPurchaseKey(data.opCode, data.id, data.dataId)
        end
        BuyUtils.InitListener(function()
            PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.IAP }, function()
                self.day = tonumber(self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                --self.eventBlackFridayModel:AddNumberBuy(EventActionType.BLACK_FRIDAY_CARD_PURCHASE, self.packId, 1)
                if self.eventBlackFridayModel.subscriptionDurationDict ~= nil then
                    local number
                    if self.eventBlackFridayModel.subscriptionDurationDict:IsContainKey(self.packId) then
                        number = tonumber(self.eventBlackFridayModel.subscriptionDurationDict:Get(self.packId) + self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                    else
                        number = tonumber(self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId))
                    end
                    self.eventBlackFridayModel.subscriptionDurationDict:Add(self.packId, number)
                end
                self:ShowPack()
            end)
        end)
        RxMgr.purchaseProduct:Next(packKey)
    else
        zg.audioMgr:PlaySfxUi(SfxUiType.DENIED)
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    end
end

--- @param left number
--- @param max number
function UICardBlackFridayItemView:ShowTextBuy(left, max)
    local day = 0
    if self.eventBlackFridayModel.subscriptionDurationDict ~= nil and self.eventBlackFridayModel.subscriptionDurationDict:IsContainKey(self.packId) then
        day = self.eventBlackFridayModel.subscriptionDurationDict:Get(self.packId)
    else
        day = self.eventConfig:GetCardDurationMaxDictionaryConfig():Get(self.packId)
    end

    if day == 7 then
        day = 6
    end

    local dayString = string.format("%s %s", day, LanguageUtils.LocalizeCommon("day_only"))

    if self.eventBlackFridayModel:IsOpening() then
        if left == nil or max == nil then
            self.config.localizeBuy.text = LanguageUtils.LocalizeCommon("buy")
        else
            local color = UIUtils.green_light
            if left == 0 then
                color = UIUtils.red_dark
                -- black friday just have 1 pack
                self.config.remainText.text = string.format(LanguageUtils.LocalizeCommon("black_friday_remain_x"), UIUtils.SetColorString(UIUtils.green_light, dayString))
                self.config.remainText.gameObject:SetActive(true)
                self.config.buttonBuy.gameObject:SetActive(false)
            else
                self.config.remainText.gameObject:SetActive(false)
                self.config.buttonBuy.gameObject:SetActive(true)
            end
            self.config.localizeBuy.text = string.format("%s %s",
                    LanguageUtils.LocalizeCommon("buy"),
                    UIUtils.SetColorString(color, string.format("(%s/%s)", left, max)))
        end
    else
        self.config.remainText.text = string.format(LanguageUtils.LocalizeCommon("black_friday_remain_x"), UIUtils.SetColorString(UIUtils.green_light, dayString))
        self.config.remainText.gameObject:SetActive(true)
        self.config.buttonBuy.gameObject:SetActive(false)
    end
end

function UICardBlackFridayItemView:CanBuy()
    local numberBought = self.eventBlackFridayModel:GetNumberBuy(EventActionType.BLACK_FRIDAY_CARD_PURCHASE, self.packId)
    return (self.data.stock - numberBought) > 0
end
