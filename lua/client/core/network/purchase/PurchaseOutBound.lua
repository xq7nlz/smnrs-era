--- @class PurchaseOutBound : OutBound
PurchaseOutBound = Class(PurchaseOutBound, OutBound)

--- @return void
------@param deviceOS DeviceOS -- check ClientConfigUtils
-----@param packId string
-----@param packName string
-----@param transactionId string
-----@param receipt string
-----@param transactionTimeInSecond number
-----@param isTest boolean
function PurchaseOutBound:Ctor(packId, isFree, deviceOS, packName, transactionId, transactionTimeInSecond, receipt, isTest)
    self.packId = packId
    self.isFree = isFree
    self.deviceOS = deviceOS
    self.packName = packName
    self.transactionId = transactionId
    self.transactionTimeInSecond = transactionTimeInSecond
    self.receipt = receipt
    self.isTest = isTest
end

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PurchaseOutBound:Serialize(buffer)
    buffer:PutInt(self.packId)
    buffer:PutBool(self.isFree)
    buffer:PutByte(self.deviceOS)
    buffer:PutString(self.packName, false)
    buffer:PutString(self.transactionId, false)
    buffer:PutLong(self.transactionTimeInSecond)
    buffer:PutString(self.receipt, false)
    buffer:PutBool(self.isTest)
end