require "lua.client.data.IdleReward.IdleItemRateConfig"

--- @class IdleItemGroupRateConfig
IdleItemGroupRateConfig = Class(IdleItemGroupRateConfig)

--- @return void
function IdleItemGroupRateConfig:Ctor()
    ---@type List --IdleItemRateConfig[]
    self.listItemRate = List()
    ---@type number
    self.groupId = 0
    ---@type number
    self.groupRate = 0
end