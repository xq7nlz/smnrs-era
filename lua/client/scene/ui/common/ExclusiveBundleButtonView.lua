--- @class ExclusiveBundleButtonView : UIPrefabView
ExclusiveBundleButtonView = Class(ExclusiveBundleButtonView, UIPrefabView)

function ExclusiveBundleButtonView:Ctor()
    ---@type ExclusiveBundleButtonConfig
    self.config = nil
    --- @type WorldSpaceHeroView
    self.worldSpaceHeroView = nil

    UIPrefabView.Ctor(self)
end
--- @return void
function ExclusiveBundleButtonView:SetPrefabName()
    self.prefabName = 'exclusive_bundle_button'
    self.uiPoolType = UIPoolType.ExclusiveBundleButtonView
end
--- @return void
--- @param transform UnityEngine_Transform
function ExclusiveBundleButtonView:SetConfig(transform)
    --- @type LineupItemConfig
    self.config = UIBaseConfig(transform)
    --- @type List
    self.rewardItems = List()

    self.config.buttonBuy.onClick:RemoveAllListeners()
    self.config.buttonBuy.onClick:AddListener(
            function()
                zg.audioMgr:PlaySfxUi(SfxUiType.BUY)
                self:OnClickBuy()
            end)
end

--- @return void
--- @param productConfig ProductConfig
--- @param price number
--- @param callbackAfterBuy function
function ExclusiveBundleButtonView:SetData(data)
    self.opCode = data.opCode
    self.productConfig = data.productConfig
    self.CallbackAfterBuy = data.callbackAfterBuy
    self:SetPackKey()
    for i, data in ipairs(self.productConfig:GetRewardList():GetItems()) do
        if data.id == MoneyType.VIP_POINT then
            self.config.textVip.text = "+" .. data.number
        else
            --- @type RootIconView
            local item =  SmartPool.Instance:SpawnLuaUIPool(UIPoolType.RootIconView, self.config.rewardAnchor)
            data.itemId = data.id
            data.quantity = data.number
            local iconData = ItemIconData.Clone(data)
            item:SetIconData(iconData)
            item:RegisterShowInfo()
            self.rewardItems:Add(item)
        end
    end
end

function ExclusiveBundleButtonView:SetPackKey()
    self.packId = self.productConfig.id
    self.purchaseKey = ClientConfigUtils.GetPurchaseKey(self.opCode, self.packId, 1)
end

function ExclusiveBundleButtonView:OnClickBuy()
    if self.isSoldOut then
        SmartPoolUtils.ShowShortNotification(LanguageUtils.LocalizeCommon("reach_limited_pack"))
    else
        BuyUtils.InitListener(
                function()
                    self:CallbackAfterBuy()
                    RxMgr.notificationPurchasePacks:Next()
                end,
                function(logicCode)
                    print("Error logic code ", logicCode)
                end)
        RxMgr.purchaseProduct:Next(self.purchaseKey)
    end
end

function ExclusiveBundleButtonView:SyncBuyState(numberBuyData)
    local stockLeft = self.productConfig.stock - numberBuyData
    self.isSoldOut = numberBuyData > 0
    local stringStockLeft = tostring(stockLeft).."/" .. self.productConfig.stock
    if stockLeft > 0 then
        stringStockLeft =  UIUtils.SetColorString(UIUtils.green_light,stringStockLeft)
    else
        stringStockLeft =  UIUtils.SetColorString(UIUtils.red_light,stringStockLeft)
    end
    self.config.limitText.text = LanguageUtils.LocalizeCommon("limit") .. " " .. stringStockLeft
    if self.isSoldOut then
        self.config.textPrice.text = LanguageUtils.LocalizeCommon("sold_out")
    else
        local price = zg.iapMgr:GetLocalPrizeString(self.purchaseKey)
        self.config.textPrice.text =  price
    end
end

--- @return void
function ExclusiveBundleButtonView:Show()
    self.config.gameObject:SetActive(true)
end

--- @return void
function ExclusiveBundleButtonView:ReturnPool()
    UIPrefabView.ReturnPool(self)
    for i = 1,  self.rewardItems:Count() do
        self.rewardItems:Get(i):ReturnPool()
    end
    self.rewardItems:Clear()
    self.config.gameObject:SetActive(false)
end

return ExclusiveBundleButtonView