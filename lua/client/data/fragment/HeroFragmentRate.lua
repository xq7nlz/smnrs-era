--- @class HeroFragmentRate
HeroFragmentRate = Class(HeroFragmentRate)

--- @return void
function HeroFragmentRate:Ctor()
    ---@type number
    self.heroId = nil
    ---@type number
    self.heroRate = nil
end

--- @return void
--- @param data string
function HeroFragmentRate:ParseCsv(data)
    self.heroId = tonumber(data.hero_id)
    self.heroRate = tonumber(data.hero_rate)
end