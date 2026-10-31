--- @class LimitedPackStatisticsInBound
LimitedPackStatisticsInBound = Class(LimitedPackStatisticsInBound)

function LimitedPackStatisticsInBound:Ctor()
    --- @type number
    self.packId = 0
    --- @type number
    self.numberOfBought = 0
    --- @type number
    self.resetTimeInSeconds = 0
end

function LimitedPackStatisticsInBound:IncreaseNumberOfBought()
    self.numberOfBought = self.numberOfBought + 1
end

function LimitedPackStatisticsInBound:GetNumberOfBought()
    return self.numberOfBought
end

--- @return LimitedPackStatisticsInBound
--- @param buffer UnifiedNetwork_ByteBuf
function LimitedPackStatisticsInBound.CreateByBuffer(buffer)
    local statistics = LimitedPackStatisticsInBound()
    statistics.packId = buffer:GetInt()
    statistics.numberOfBought = buffer:GetByte()
    statistics.resetTimeInSeconds = buffer:GetLong()
    return statistics
end