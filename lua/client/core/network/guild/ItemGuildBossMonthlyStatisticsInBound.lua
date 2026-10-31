--- @class ItemGuildBossMonthlyStatisticsInBound
ItemGuildBossMonthlyStatisticsInBound = Class(ItemGuildBossMonthlyStatisticsInBound)

--- @param buffer UnifiedNetwork_ByteBuf
function ItemGuildBossMonthlyStatisticsInBound:Ctor(buffer)
    --- @type number
    self.playerId = buffer:GetLong()
    --- @type number
    self.score = buffer:GetLong()
    --- @type number
    self.updatedTime = buffer:GetLong()
end