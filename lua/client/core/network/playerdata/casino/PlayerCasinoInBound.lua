require "lua.client.core.network.playerData.casino.CasinoItemInBound"

--- @class PlayerCasinoInBound
PlayerCasinoInBound = Class(PlayerCasinoInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerCasinoInBound:ReadBuffer(buffer)
    ---@type List
    self.baseCasinoItems = NetworkUtils.GetListDataInBound(buffer, CasinoItemInBound)
    ---@type List
    self.premiumCasinoItems = NetworkUtils.GetListDataInBound(buffer, CasinoItemInBound)

    ---@type number
    self.lastTimeRefreshBase = buffer:GetLong()
    ---@type number
    self.lastTimeRefreshPremium = buffer:GetLong()
    ---@type number
    self.numberRefreshBase = buffer:GetByte()
    ---@type number
    self.numberRefreshPremium = buffer:GetByte()
    ---@type number
    self.turnBuyChip = buffer:GetByte()
    ---@type number
    self.numberWatchAdBasic = buffer:GetInt()
    ---@type number
    self.numberWatchAdPremium = buffer:GetInt()
end

--- @return void
function PlayerCasinoInBound:ToString()
    return LogUtils.ToDetail(self)
end