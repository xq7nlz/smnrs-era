--- @class HeroFragmentNumberConfig
HeroFragmentNumberConfig = Class(HeroFragmentNumberConfig)

--- @return void
function HeroFragmentNumberConfig:Ctor()
    --- @type number
    self.star = nil
    --- @type number
    self.number = nil
end

--- @return void
--- @param data string
function HeroFragmentNumberConfig:ParseCsv(data)
    self.star = tonumber(data.star)
    self.number = tonumber(data.number_to_summon_hero)
end