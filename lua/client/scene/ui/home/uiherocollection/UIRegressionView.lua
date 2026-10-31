--- @class UIRegressionView
UIRegressionView = Class(UIRegressionView)

function UIRegressionView:Ctor(uiTransform)
    self.listMoney = List()
    self.listReward = List()
    ---@type HeroResource
    self.heroResource = nil
    ---@type HeroIconView
    self.heroIconView = nil
    ---@type MoneyIconView
    self.moneyView = nil
    ---@type UIRegressionConfig
    self.config = UIBaseConfig(uiTransform)
    ---@type RegressionConfig
    self.regressionConfig = ResourceMgr.GetRegressionConfig()

    --- @param obj RootIconView
    --- @param index number
    local onUpdateItem = function(obj, index)
        obj:SetIconData(self.listRefund:Get(index + 1))
    end
    --- @param obj RootIconView
    --- @param index number
    local onCreateItem = function(obj, index)
        obj:SetSize(150, 150)
        onUpdateItem(obj, index)
        --obj:RegisterShowInfo()
    end
    ---@type UILoopScroll
    self.uiScroll = UILoopScroll(self.config.scroll, UIPoolType.RootIconView, onCreateItem, onUpdateItem)

    self.config.slotButton.onClick:AddListener(function()
        self:OnClickSelectHero()
    end)
    self.config.buttonAsk.onClick:AddListener(function()
        self:OnClickHelp()
    end)
    self.config.buttonRegression.onClick:AddListener(function()
        self:OnClickRegression()
    end)
end

function UIRegressionView:InitLocalization()
    self.config.textRegression.text = LanguageUtils.LocalizeCommon("regression")
    self.config.textPopupContent.text = LanguageUtils.LocalizeCommon("regression_reward")
end

function UIRegressionView:Show()
    self.config.gameObject:SetActive(true)
    self:UpdateView()
end

function UIRegressionView:UpdateView()
    self:HideResource()
    self:HideHero()
    if self.moneyView == nil then
        self.moneyView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.money)
    end
    self.moneyView:SetIconData(ItemIconData.CreateInstance(ResourceType.Money, MoneyType.REGRESSION_CURRENCY, 0))
    self.moneyView:RegisterShowInfo()
    self.moneyView:SetQuantityAndInventory()

    if self.heroInventoryId ~= nil then
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.heroInventoryId)
        if self.heroIconView == nil then
            ---@type HeroIconView
            self.heroIconView = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.HeroIconView, self.config.slotButton.transform)
        end
        self.heroIconView:SetIconData(HeroIconData.CreateByHeroResource(heroResource))

        self.moneyView:ReturnPool()
        self.moneyView = nil
        ---@type RegressionPrice
        local price = self.regressionConfig:GetDictPrice():Get(heroResource.heroStar)
        ---@param v ItemIconData
        for i, v in ipairs(price.listMoney:GetItems()) do
            ---@type MoneyIconView
            local money = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.MoneyIconView, self.config.money)
            money:SetIconData(v)
            money:RegisterShowInfo()
            money:SetQuantityAndInventory()
            self.listMoney:Add(money)
        end

        self.listRefund = List()
        self.listRefund:Add(HeroIconData.CreateInstance(ResourceType.Hero, heroResource.heroId, self.regressionConfig:GetBaseStar(), 1,
                ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)))
        ---@param v HeroMaterialEvolveData
        for _, v in ipairs(heroResource:GetListFood():GetItems()) do
            if v.materialId == HeroFoodRefundType.SAME_HERO then
                for i = 1, v.number do
                    self.listRefund:Add(HeroIconData.CreateInstance(ResourceType.Hero, heroResource.heroId, v.star, 1,
                            ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)))
                end
            elseif v.materialId == HeroFoodRefundType.SAME_FACTION then
                self.listRefund:Add(ItemIconData.CreateBuyHeroFood(
                        ClientConfigUtils.GetFoodFactionByFaction(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId)),
                        v.star, v.number))
            elseif v.materialId == HeroFoodRefundType.RANDOM_HERO then
                self.listRefund:Add(ItemIconData.CreateBuyHeroFood(
                        HeroFoodType.MOON,
                        v.star, v.number))
            end
        end

        self.heroEvolvePriceDict = ResourceMgr.GetHeroMenuConfig():_GetHeroEvolvePriceConfigDict()

        local numberFoodSameFaction = 0
        local numberFoodAny = 0
        local foodSameFactionType = ClientConfigUtils.GetOrbByFaction(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
        local foodAnyType = ClientConfigUtils.GetMoonSunOrbByFaction(ClientConfigUtils.GetFactionIdByHeroId(heroResource.heroId))
        for i = self.regressionConfig:GetBaseStar() + 1, heroResource.heroStar do
            local orbEvolveData = self.heroEvolvePriceDict:Get(i).orbEvolveData
            for i = 1, orbEvolveData:Count() do
                if orbEvolveData:Get(i).orbId == 0 then
                    numberFoodAny = numberFoodAny + orbEvolveData:Get(i).number
                else
                    numberFoodSameFaction = numberFoodSameFaction + orbEvolveData:Get(i).number
                end
            end
        end

        local foodSameFactionIconData = ItemIconData.CreateInstance(ResourceType.Money, foodSameFactionType, numberFoodSameFaction)
        local foodAnyIconData = ItemIconData.CreateInstance(ResourceType.Money, foodAnyType, numberFoodAny)

        if numberFoodAny > 0 then
            self.listRefund:Add(foodAnyIconData)
        end
        if numberFoodSameFaction > 0 then
            self.listRefund:Add(foodSameFactionIconData)
        end

        ClientConfigUtils.AddListItemIconData(self.listRefund, heroResource:GetResourceRegression())

        if self.listRefund:Count() < 8 then
            self.config.reward.gameObject:SetActive(true)
            for i, v in ipairs(self.listRefund:GetItems()) do
                local item = SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.reward)
                item:SetIconData(v)
                self.listReward:Add(item)
            end
        else
            self.uiScroll.scroll.gameObject:SetActive(true)
            self.uiScroll:Resize(self.listRefund:Count())
        end
    else

    end
    self.config.softTut:SetActive(NotificationCheckUtils.IsCanShowSoftTutRegression() and self.heroInventoryId == nil)
    self.config.softTutRegression:SetActive(NotificationCheckUtils.IsCanShowSoftTutRegression() and self.heroInventoryId ~= nil)
end

function UIRegressionView:Hide()
    if self.config.gameObject.activeInHierarchy then
        self:HideHero()
        self:HideResource()
        self.config.gameObject:SetActive(false)
        self.heroInventoryId = nil
    end
end

function UIRegressionView:HideHero()
    self.heroResource = nil
    if self.heroIconView ~= nil then
        self.heroIconView:ReturnPool()
        self.heroIconView = nil
    end
end

function UIRegressionView:HideResource()
    self.config.reward.gameObject:SetActive(false)
    self.uiScroll:Hide()
    self.uiScroll.scroll.gameObject:SetActive(false)
    if self.listReward ~= nil then
        ---@param v IconView
        for i, v in ipairs(self.listReward:GetItems()) do
            v:ReturnPool()
        end
        self.listReward:Clear()
    end
    if self.listMoney ~= nil then
        ---@param v IconView
        for i, v in ipairs(self.listMoney:GetItems()) do
            v:ReturnPool()
        end
        self.listMoney:Clear()
    end
    if self.moneyView ~= nil then
        self.moneyView:ReturnPool()
        self.moneyView = nil
    end
end

function UIRegressionView:OnClickHelp()
    local info = LanguageUtils.LocalizeHelpInfo("regression_info")
    PopupMgr.ShowPopup(UIPopupName.UIHelpInfo, info)
end

function UIRegressionView:OnClickSelectHero()
    local data = {}
    data.heroInventoryId = self.heroInventoryId
    data.selectCallback = function(selectedId)
        self.heroInventoryId = selectedId
        self:UpdateView()
        if NotificationCheckUtils.IsCanShowSoftTutRegression() then
            zg.playerData.remoteConfig.softTutRegression = zg.timeMgr:GetServerTime()
            zg.playerData:SaveRemoteConfig()
        end
    end
    data.callbackClose = function()
        PopupMgr.HidePopup(UIPopupName.UISelectHeroRegression)
        if NotificationCheckUtils.IsCanShowSoftTutRegression() then
            zg.playerData.remoteConfig.softTutRegression = zg.timeMgr:GetServerTime()
            zg.playerData:SaveRemoteConfig()
        end
        self:UpdateView()
    end
    PopupMgr.ShowPopup(UIPopupName.UISelectHeroRegression, data)
end

function UIRegressionView:OnClickRegression()
    if self.heroInventoryId ~= nil then
        self.config.softTutRegression:SetActive(NotificationCheckUtils.IsCanShowSoftTutRegression() and self.heroInventoryId ~= nil)
        local listMoney = List()
        ---@type HeroResource
        local heroResource = InventoryUtils.GetHeroResourceByInventoryId(self.heroInventoryId)
        local price = self.regressionConfig:GetDictPrice():Get(heroResource.heroStar)
        ---@param v ItemIconData
        for i, v in ipairs(price.listMoney:GetItems()) do
            listMoney:Add(RewardInBound.CreateBySingleParam(ResourceType.Money, v.itemId, v.quantity))
        end
        if InventoryUtils.IsEnoughMultiResourceRequirement(listMoney, true) then
            PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("confirm_regression"), nil, function()
                self:RequestRegression()
            end)
        end
    else
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("you_need_select_hero"))
    end
end

function UIRegressionView:RequestRegression()
    --- @param buffer UnifiedNetwork_ByteBuf
    local onBufferReading = function(buffer)
        ---@type List
        self.rewardItems = NetworkUtils.GetRewardInBoundList(buffer)
    end

    NetworkUtils.RequestAndCallback(OpCode.REGRESS_HERO, UnknownOutBound.CreateInstance(
            PutMethod.Long, self.heroInventoryId), function()
        PopupUtils.ShowRewardList(self.listRefund)
        self.heroInventoryId = nil
        self:UpdateView()
        PlayerDataRequest.RequestAndCallback({ PlayerDataMethod.BASIC_INFO, PlayerDataMethod.HERO_COLLECTION, PlayerDataMethod.ITEM_COLLECTION, PlayerDataMethod.HERO_EVOLVE_FOOD }, function()
            self:UpdateView()
        end)
    end, SmartPoolUtils.LogicCodeNotification)
end
