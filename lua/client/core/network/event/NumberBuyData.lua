--- @class NumberBuyData
NumberBuyData = Class(NumberBuyData)

function NumberBuyData:Ctor()
    self.buyStatsDict = Dictionary()
end

--- @param buffer UnifiedNetwork_ByteBuf
function NumberBuyData:ReadBuffer(buffer)
    local size = buffer:GetByte()
    for i = 1, size do
        local packId = buffer:GetShort()
        local numberOfBought = buffer:GetShort()
        self.buyStatsDict:Add(packId, numberOfBought)
    end
end

function NumberBuyData:GetNumberOfBoughtWithPackId(packId)
    if self.buyStatsDict:IsContainKey(packId) then
        return self.buyStatsDict:Get(packId)
    end
    self.buyStatsDict:Add(packId, 0)
    return 0
end

function NumberBuyData:AddNumberBoughtWithPackId(packId)
    if self.buyStatsDict:IsContainKey(packId) then
        self.buyStatsDict:Add(packId,  self.buyStatsDict:Get(packId) + 1)
    else
        self.buyStatsDict:Add(packId, 1)
    end
end

function NumberBuyData:ResetNumberBuyMarketItem()
    self.buyStatsDict:Clear()
end

--- @class NumberBuyPurchase
NumberBuyPurchase = Class(NumberBuyPurchase)

function NumberBuyPurchase:Ctor(numberBuyData, packId)
    ---@type NumberBuyData
    self.numberBuyData = numberBuyData
    self.packId = packId
end

function NumberBuyPurchase:IncreaseNumberOfBought()
    self.numberBuyData:AddNumberBoughtWithPackId(self.packId)
end

function NumberBuyPurchase:GetNumberOfBought()
    return self.numberBuyData:GetNumberOfBoughtWithPackId(self.packId)
end