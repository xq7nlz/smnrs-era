require "lua.client.data.Purchase.LevelPass.GrowthPackLineConfig"

--- @class EventArenaPassConfig
EventArenaPassConfig = Class(EventArenaPassConfig)

local GROWTH_PACK_BASIC = "csv/event/event_arena_pass/data_%d/arena_pass_free_reward.csv"
local GROWTH_PACK_PREMIUM = "csv/event/event_arena_pass/data_%d/arena_pass_premium_reward.csv"

function EventArenaPassConfig:Ctor()
    --- @type Dictionary
    self.lineConfig = Dictionary()
end

--- @return GrowthPackLineConfig
--- @param dataId number
function EventArenaPassConfig:GetConfig(dataId)
    if self.lineConfig:IsContainKey(dataId) == false then
        self:_InitLineConfig(dataId)
    end
    return self.lineConfig:Get(dataId)
end

--- @param dataId number
function EventArenaPassConfig:_InitLineConfig(dataId)
    local growthPackLineConfig = GrowthPackLineConfig(dataId, GROWTH_PACK_BASIC, GROWTH_PACK_PREMIUM, "number")
    self.lineConfig:Add(dataId, growthPackLineConfig)
end

return EventArenaPassConfig