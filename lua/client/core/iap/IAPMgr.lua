require "lua.client.core.network.purchase.PurchaseRequest"
require "lua.client.core.iap.IAPReceiptFactory"

local MAX_RETRY = 3

--- @class IAPMgr
IAPMgr = Class(IAPMgr)

--- @return void
function IAPMgr:Ctor()
    --- @type CS_IAPMgr
    self.iapMgr = zgUnity.iapMgr
    --- @type boolean
    self.isPurchasing = false
    --- @type boolean
    self.initialized = false
    ---@type EventDispatcherListener
    self.onPurchaseListener = nil
    --- @type number
    self.numberRetryInitPurchase = 0
    --- @type function
    self.onInitializedComplete = nil
    --- @type boolean
    self.isAvailableToRequestPendingPurchase = false

    --- @type Dictionary
    self.localPriceDict = Dictionary()
    self:InitListener()
    self:OnInitializedComplete()
    self:OnPurchaseComplete()
end

--- @return void
function IAPMgr:InitListener()
    self.onPurchaseListener = RxMgr.purchaseProduct:Subscribe(RxMgr.CreateFunction(self, self.OnPurchaseProduct))
end

--- @return void
function IAPMgr:RemoveListener()
    if self.onPurchaseListener then
        self.onPurchaseListener:Unsubscribe()
    end
end

--- @return void
function IAPMgr:InitProduct()
    if self.initialized then
        self.iapMgr:CheckPendingReceipt()
    else
        local packBaseDict = ResourceMgr.GetPurchaseConfig():GetAllPackBase()
        --- @param value ProductConfig
        for key, value in pairs(packBaseDict:GetItems()) do
            if value.isFree ~= true then
                self.iapMgr:AddProduct(key, value.androidPackageName, value.iosPackageName)
            end
        end
        self:InitPurchasing()
    end
end

function IAPMgr:InitPurchasing()
    self.numberRetryInitPurchase = self.numberRetryInitPurchase + 1
    self.iapMgr:InitPurchasing()
end

--- @return void
function IAPMgr:OnInitializedComplete()
    --PurchasingUnavailable = 0,
    --NoProductsAvailable = 1,
    --AppNotKnown = 2
    --- @param error number -1: ok
    self.iapMgr.onInitializedComplete = function(error)
        if error == -1 then
            self.initialized = true
            self:InitLocalPrice()
            RxMgr.onIAPInitializedComplete:Next()
            if self.onInitializedComplete ~= nil then
                self.onInitializedComplete()
            end
        else
            if self.numberRetryInitPurchase < MAX_RETRY then
                self:InitPurchasing()
            else
                if self.onInitializedComplete ~= nil then
                    self.onInitializedComplete()
                else
                    XDebug.Log("initialize nil")
                end
                XDebug.Warning(string.format("Init purchase failed: %d", error))
            end
        end
    end
end

--- @param productId string
function IAPMgr:ShowInitPurchaseFailed(productId)
    local noCallback = function()
        zg.audioMgr:PlaySfxUi(SfxUiType.BACK)
    end
    local yesCallback = function()
        PopupMgr.ShowPopup(UIPopupName.UIPopupWaiting, OpCode.PURCHASE_RAW_PACK)
        zg.audioMgr:PlaySfxUi(SfxUiType.CONFIRM)
        Coroutine.start(function()
            coroutine.waitforseconds(1)
            if self.onInitializedComplete == nil then
                self.onInitializedComplete = function()
                    self.onInitializedComplete = nil
                    self:OnPurchaseProduct(productId)
                    PopupMgr.HidePopup(UIPopupName.UIPopupWaiting)
                end
            end
            self.numberRetryInitPurchase = 0
            self:InitPurchasing()
        end)
    end
    PopupUtils.ShowPopupNotificationYesNo(LanguageUtils.LocalizeCommon("init_proceed_failed"), noCallback, yesCallback)
end

--- @return void
--- @param productId string
function IAPMgr:OnPurchaseProduct(productId)
    local productConfig = ResourceMgr.GetPurchaseConfig():GetPackBase(productId)
    if productConfig == nil then
        XDebug.Error("Product config not found: " .. productId);
        return
    end
    XDebug.Log("Purchase product: " .. tostring(productId))
    if productConfig.isFree then
        PurchaseRequest.FreeRequest(productConfig)
        return
    end

    if self.initialized == false then
        self:ShowInitPurchaseFailed(productId)
        return
    end

    if IS_MOBILE_PLATFORM then
        zg.playerData.waitingPauseAction = true
        UIPopupWaitingUtils.ShowWaiting()
        self.iapMgr:Purchase(productId)
    else
        if productConfig.opCode == OpCode.PURCHASE_PROGRESS_PACK then
            productConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetProgressPackWithId(productConfig.id)
        end
        local receipt = IAPReceiptFactory.GetReceipt(productConfig.androidPackageName)
        PurchaseRequest.Purchasing(productConfig, receipt)
    end
end

--- @return void
function IAPMgr:OnPurchaseComplete()
    --- @param purchaseResponseCode PurchaseResponseCode
    --- @param content string
    self.iapMgr.onPurchaseComplete = function(purchaseResponseCode, content)
        UIPopupWaitingUtils.StopWaitingCoroutine()

        if purchaseResponseCode == PurchaseResponseCode.Success then
            local receipt = IAPReceiptFactory.GetReceipt(content)
            self:OnPurchaseSuccessWithReceipt(receipt)
        elseif purchaseResponseCode == PurchaseResponseCode.DuplicateTransaction then
            self.iapMgr:CheckPendingReceipt()
        else
            if purchaseResponseCode == PurchaseResponseCode.Unknown then
                self:ShowPurchaseFailed(content)
            end
        end
    end
end

--- @param receipt {pack_name}
function IAPMgr:OnPurchaseSuccessWithReceipt(receipt)
    EventInBound.ReValidateEventData()
    local packageName = receipt.pack_name
    local productConfig = ResourceMgr.GetPurchaseConfig():GetProductByPackage(packageName)
    local productId = productConfig.productID
    if productConfig.opCode == OpCode.PURCHASE_PROGRESS_PACK then
        productConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetProgressPackWithId(productConfig.id)
    end

    PurchaseRequest.Purchasing(productConfig, receipt, function(isSuccess, isTesterOrder)
        self.iapMgr:ConfirmPendingPurchase(productId)
        if isSuccess and isTesterOrder == false then
            --- Fire tracking event
        end
    end)
end

--- @param productId string
function IAPMgr:ShowPurchaseFailed(productId)
    PopupUtils.ShowPopupNotificationOK(LanguageUtils.LocalizeCommon("init_proceed_failed"), function()
        SceneMgr.RequestAndResetToMainArea()
    end)
end

--- @return string
--- @param productId
function IAPMgr:GetLocalPrizeString(productId)
    assert(productId)
    if self.initialized then
        local product = self.iapMgr.Products:WithID(productId)
        if product ~= nil and product.availableToPurchase == true then
            return product.metadata.localizedPriceString
        end
    else
        return self:GetConfigPrice(productId)
    end
end

--- @return string
--- @param price number
function IAPMgr:ConvertLocalPrice(price)
    for k, v in pairs(self.localPriceDict:GetItems()) do
        if k == price then
            return v
        end
    end
end

--- @return string
function IAPMgr:InitLocalPrice()
    local packs = ResourceMgr.GetPurchaseConfig():GetPackBaseDict()
    --- @param v ProductConfig
    --- @param k number
    for k, v in pairs(packs:GetItems()) do
        if self.localPriceDict:Get(tonumber(v.dollarPrice)) == nil then
            local product = self.iapMgr.Products:WithID(v.productID)
            if product ~= nil then
                local localizedPriceString = product.metadata.localizedPriceString
                if localizedPriceString ~= nil then
                    local data = {}
                    data.price = localizedPriceString
                    data.productID = v.productID
                    self.localPriceDict:Add(tonumber(v.dollarPrice), data)
                end
            end
        end
    end
end

function IAPMgr:GetConfigPrice(productId)
    local productConfig = ResourceMgr.GetPurchaseConfig():GetPackBase(productId)
    return string.format("%s$", productConfig.dollarPrice)
end