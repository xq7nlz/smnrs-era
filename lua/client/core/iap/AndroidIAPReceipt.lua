--- @class AndroidIAPReceipt
AndroidIAPReceipt = Class(AndroidIAPReceipt, IAPReceipt)

function AndroidIAPReceipt:Ctor(content)
    XDebug.Log("IAP content: " .. content)

    IAPReceipt.Ctor(self)
    self.is_test = false

    local product = json.decode(content)
    self:SetReceipt(product["receipt"])
    IAPReceipt.SetMetaData(self, product["metadata"])
    IAPReceipt.SetProductConfig(self)
end

function AndroidIAPReceipt:SetMetaData(metadata)
    self.isoCurrencyCode = metadata["isoCurrencyCode"]
    self.localizedPrice = metadata["localizedPrice"]
end

--- @param receipt string
function AndroidIAPReceipt:SetReceipt(receipt)
    IAPReceipt.SetReceipt(self, receipt)
    local data = json.decode(receipt)
    local payLoad = json.decode(data["Payload"])
    local detail = json.decode(payLoad["json"])
    self.transaction_id = detail["orderId"]
    if IS_IOS_PLATFORM then
        self.transaction_id = data["TransactionID"]
    end
    self.pack_name = detail["productId"]
    self.receipt = detail["purchaseToken"]
end

