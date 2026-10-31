--- @class BoostFirstPurchaseCollection
BoostFirstPurchaseCollection = Class(BoostFirstPurchaseCollection)

function BoostFirstPurchaseCollection:Ctor()
    ---@type number
    self.createdTime = nil
    ---@type number
    self.groupActive = nil
    ---@type Dictionary
    self.boughtPackDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function BoostFirstPurchaseCollection:ReadBuffer(buffer)
    self.createdTime = buffer:GetLong()
    self.groupActive = buffer:GetInt()
    for _ = 1, buffer:GetByte() do
        self.boughtPackDict:Add(buffer:GetInt(), buffer:GetInt())
    end
end

--- @return List | GroupProductConfig
function BoostFirstPurchaseCollection:GetActiveGroupBoostFirstPurchase()
    --- @type BoostFirstPurchasePackOfProducts
    local iapConfig = ResourceMgr.GetPurchaseConfig():GetCashShop():GetPack(OpCode.PURCHASE_BOOST_FIRST_PACK)
    ---@type GroupProductConfig
    local group = iapConfig:GetGroup(self.groupActive)
    if group ~= nil and group:IsActiveByDuration(self.createdTime) then
        return group
    end
    return 0
end

--- @return number
--- @param packId number
function BoostFirstPurchaseCollection:GetBoughtCount(packId)
    if self.boughtPackDict:IsContainKey(packId) then
        return self.boughtPackDict:Get(packId)
    end
    return 0
end

--- @param packId number
function BoostFirstPurchaseCollection:IncreaseBoughtPack(packId)
    local bought = self:GetBoughtCount(packId)
    self.boughtPackDict:Add(packId, bought + 1)
end

--- @return number
--- @param packId number
function BoostFirstPurchaseCollection:GetCreatedTime()
    return self.createdTime
end