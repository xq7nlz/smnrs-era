require "lua.client.data.Fragment.HeroFragmentRate"

--- @class HeroFragmentGroupRate
HeroFragmentGroupRate = Class(HeroFragmentGroupRate)

--- @return void
function HeroFragmentGroupRate:Ctor()
    ---@type List --HeroFragmentRate[]
    self.listHeroRate = List()
    ---@type number
    self.groupId = 0
    ---@type number
    self.groupRate = 0
end

--- @return void
--- @param data string
function HeroFragmentGroupRate:ParseCsv(data)
    self.groupId = tonumber(data.group) + 1
    self.groupRate = tonumber(data.group_rate)
end