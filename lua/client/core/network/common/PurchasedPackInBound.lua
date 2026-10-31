--- @class PurchasedPackInBound
PurchasedPackInBound = Class(PurchasedPackInBound)

function PurchasedPackInBound:Ctor()
    --- @type number
    self.packId = 0
    self.numberOfBought = 0
    --- @type ProductConfig
    self.config = nil
end

--- @param config ProductConfig
function PurchasedPackInBound:SetConfig(config)
    self.config = config
end

function PurchasedPackInBound:IncreaseNumberOfBought(number)
    number = number or 1
    self.numberOfBought = self.numberOfBought + number
end

--- @param buffer UnifiedNetwork_ByteBuf
function PurchasedPackInBound.CreateByBuffer(buffer)
    local data = PurchasedPackInBound()
    data.packId = buffer:GetInt()
    data.numberOfBought = buffer:GetInt()
    return data
end