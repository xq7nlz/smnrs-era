--- @class iOSIAPReceipt
iOSIAPReceipt = Class(iOSIAPReceipt, IAPReceipt)

function iOSIAPReceipt:Ctor(content)
    IAPReceipt.Ctor(self, content)

    self.is_test = false
    self:ParseContent(content)
end

function iOSIAPReceipt:ParseContent(content)
    local data = json.decode(content)
    local definition = data["definition"]
    self.transaction_id = data["transactionID"]
    self.receipt = json.decode(data["receipt"])["Payload"]
    self.pack_name = definition["storeSpecificId"]
    IAPReceipt.SetMetaData(self, data["metadata"])
    IAPReceipt.SetProductConfig(self)
end

