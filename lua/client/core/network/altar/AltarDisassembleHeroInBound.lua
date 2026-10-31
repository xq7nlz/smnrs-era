require "lua.client.core.network.playerData.common.DynamicRewardInBound"

--- @class AltarDisassembleHeroInBound
AltarDisassembleHeroInBound = Class(AltarDisassembleHeroInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function AltarDisassembleHeroInBound:Ctor(buffer)
    ---@type List
    self.rewardItems = NetworkUtils.GetRewardInBoundList(buffer)
end

--- @return void
function AltarDisassembleHeroInBound:ToString()
    return LogUtils.ToDetail(self)
end