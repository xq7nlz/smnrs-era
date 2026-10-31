--- @class SaleOffProductConfig : ProductConfig
SaleOffProductConfig = Class(SaleOffProductConfig, ProductConfig)

--- @return void
function SaleOffProductConfig:Ctor()
    ProductConfig.Ctor(self)
    --- @type number
    self.originalPackId = nil
    --- @type PackViewType
    self.transactionType = nil
    --- @type number
    self.saleOff = nil
end

--- @return void
--- @param data string
function SaleOffProductConfig:ParseCsv(data)
    ProductConfig.ParseCsv(self, data)
    self.transactionType = tonumber(data["transaction_type"])
    self.saleOff = tonumber(data["sale"])
    self.originalPackId = tonumber(data["original_pack_id"])
end

--- @return boolean
--- @param packId number
--- @param opCode OpCode
function SaleOffProductConfig:CompareToOriginPack(packId, opCode)
    return SaleOffProductConfig.GetOpCodeTypeTransactionType(self.transactionType) == opCode
            and packId == self.originalPackId
end

--- @return OpCode
--- @param transactionType PackViewType
function SaleOffProductConfig.GetOpCodeTypeTransactionType(transactionType)
    if transactionType == PackViewType.RAW_PACK then
        return OpCode.PURCHASE_RAW_PACK
    elseif transactionType == PackViewType.SUBSCRIPTION_PACK then
        return OpCode.PURCHASE_SUBSCRIPTION_PACK
    elseif transactionType == PackViewType.FIRST_TIME_PACK then
        return OpCode.PURCHASE_PROGRESS_PACK
    elseif transactionType == PackViewType.LIMITED_PACK then
        return OpCode.PURCHASE_LIMITED_PACK
    elseif transactionType == PackViewType.EVENT_BUNDLE then
        return OpCode.EVENT_BUNDLE_PURCHASE
    elseif transactionType == PackViewType.EVENT_HOT_DEAL then
        return OpCode.EVENT_HOT_DEAL_PURCHASE
    elseif transactionType == PackViewType.STARTER_PACK then
        return OpCode.PURCHASE_PROGRESS_PACK
    else
        XDebug.Error("missing off code by transaction type " .. transactionType)
    end
end

--- @return List <RewardInBound>
function SaleOffProductConfig:GetRewardList()
    local originProductId = ClientConfigUtils.GetPurchaseKey(SaleOffProductConfig.GetOpCodeTypeTransactionType(self.transactionType),
            self.originalPackId)
    local productConfig = ResourceMgr.GetPurchaseConfig():GetPackBase(originProductId)
    return productConfig:GetRewardList()
end

function SaleOffProductConfig:ClaimAndShowRewardList()
    --- @type SubscriptionProduct
    local subscriptionProduct = ResourceMgr.GetPurchaseConfig():GetCashShop():GetSubscription(self.originalPackId)
    if subscriptionProduct.allowSkipVideo == true then
        --- @type IapDataInBound
        local iap = zg.playerData:GetMethod(PlayerDataMethod.IAP)
        iap.allowSkipVideo = true
    end
    PopupUtils.ClaimAndShowRewardList(self:GetRewardList())
end