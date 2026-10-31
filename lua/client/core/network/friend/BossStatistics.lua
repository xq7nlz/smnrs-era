--- @class BossStatistics
BossStatistics = Class(BossStatistics)

--- @return void
function BossStatistics:Ctor()
    --- @type number
    self.playerId = nil
    --- @type string
    self.playerName = nil
    --- @type number
    self.playerAvatar = nil
    --- @type number
    self.playerLevel = nil
    --- @type number
    self.damage = nil
end

--- @return BossStatistics
--- @param buffer UnifiedNetwork_ByteBuf
function BossStatistics.CreateByBuffer(buffer)
    ---@type BossStatistics
    local data = BossStatistics()
    data.playerId = buffer:GetLong()
    data.playerName = buffer:GetString()
    data.playerAvatar = buffer:GetInt()
    data.playerLevel = buffer:GetShort()
    data.damage = buffer:GetLong()
    return data
end

--- @return number
---@param x BossStatistics
---@param y BossStatistics
function BossStatistics.BossStatisticsSortDamage(x, y)
    if (x.damage > y.damage) then
        return -1
    else
        return 1
    end
end