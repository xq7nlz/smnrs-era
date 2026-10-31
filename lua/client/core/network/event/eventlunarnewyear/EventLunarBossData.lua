require "lua.client.core.network.playerData.common.HeroStateInBound"

--- @class EventLunarBossData
EventLunarBossData = Class(EventLunarBossData)

function EventLunarBossData:Ctor(buffer)
    --- @type number
    self.recentPassedChap = nil
    --- @type number
    self.currentChap = nil
    --- @type number
    self.totalGuildPoint = nil
    if buffer ~= nil then
        self:ReadBuffer(buffer)
    end
end

--- @param buffer UnifiedNetwork_ByteBuf
function EventLunarBossData:ReadBuffer(buffer)
    self.recentPassedChap = buffer:GetInt()
    self.currentChap = buffer:GetInt()
    self.totalGuildPoint = buffer:GetLong() - InventoryUtils.Get(ResourceType.Money, MoneyType.EVENT_LUNAR_NEW_GUILD_POINT)
    --XDebug.Log(LogUtils.ToDetail(self))
end