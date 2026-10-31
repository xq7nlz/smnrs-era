--- @class IAPReceipt
IAPReceipt = Class(IAPReceipt)

function IAPReceipt:Ctor()
    self.device_os = ClientConfigUtils.GetDeviceOS()
    self.transaction_time = os.time()
    --- @type boolean
    self.is_test = nil
    --- @type boolean
    self.is_free = nil
    --- @type string
    self.transaction_id = nil
    --- @type string
    self.receipt = nil
    --- @type string
    self.pack_id = nil
    --- @type string
    self.pack_name = nil
    --- @type string
    self.isoCurrencyCode = nil
    --- @type number
    self.localizedPrice = nil
    --- @type ProductConfig
    self.productConfig = nil
end

--- @param receipt string
function IAPReceipt:SetReceipt(receipt)
    self.receipt = receipt
end

function IAPReceipt:SetMetaData(metadata)
    self.isoCurrencyCode = metadata["isoCurrencyCode"]
    self.localizedPrice = metadata["localizedPrice"]
end

function IAPReceipt:SetProductConfig()
    self.productConfig = ResourceMgr.GetPurchaseConfig():GetProductByPackage(self.pack_name)
    self.pack_id = self.productConfig.id
    self.is_free = self.productConfig.isFree
end
