require "lua.client.core.network.playerData.casino.CasinoItemInBound"

--- @class RefreshCasinoInBound
RefreshCasinoInBound = Class(RefreshCasinoInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function RefreshCasinoInBound:Ctor(buffer)
    ---@type number
    self.casinoType = buffer:GetByte()
    ---@type boolean
    self.isFree = buffer:GetBool()
    ---@type List
    self.casinoItems = NetworkUtils.GetListDataInBound(buffer, CasinoItemInBound)
end

--- @return void
function RefreshCasinoInBound:ToString()
    return LogUtils.ToDetail(self)
end