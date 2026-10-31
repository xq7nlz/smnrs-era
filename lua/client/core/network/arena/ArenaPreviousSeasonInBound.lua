--- @class ArenaPreviousSeasonInBound
ArenaPreviousSeasonInBound = Class(ArenaPreviousSeasonInBound)

--- @return void
function ArenaPreviousSeasonInBound:Ctor()
    ---@type number
    self.rankingOder = nil
    ---@type number
    self.rankingType = nil
    ---@type number
    self.season = nil
end

--- @return ArenaPreviousSeasonInBound
--- @param buffer UnifiedNetwork_ByteBuf
function ArenaPreviousSeasonInBound.CreateByBuffer(buffer)
    local data = ArenaPreviousSeasonInBound()
    data.rankingOder = buffer:GetInt()
    data.rankingType = buffer:GetByte()
    data.season = buffer:GetLong()
    return data
end