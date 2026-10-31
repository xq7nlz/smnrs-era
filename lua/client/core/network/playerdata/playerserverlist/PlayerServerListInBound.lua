require "lua.client.core.network.playerData.playerServerList.PlayerServerData"

--- @class PlayerServerListInBound
PlayerServerListInBound = Class(PlayerServerListInBound)

--- @return void
--- @param buffer UnifiedNetwork_ByteBuf
function PlayerServerListInBound:ReadBuffer(buffer)
    ---@type number
    local size = buffer:GetShort()
    ---@type List  --<PlayerServerData>
    self.listPlayer = List()
    for _ = 1, size do
        self.listPlayer:Add(PlayerServerData(buffer))
    end

    --for _, v in pairs(self.listPlayer:GetItems()) do
    --    XDebug.Log("PlayerServerListInBound" .. LogUtils.ToDetail(v))
    --end
end

--- @return void
function PlayerServerListInBound:ToString()
    return LogUtils.ToDetail(self)
end