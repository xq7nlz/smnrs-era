--- @class HeroLevelCapConfig
HeroLevelCapConfig = Class(HeroLevelCapConfig)

--- @return void
function HeroLevelCapConfig:Ctor()
    ---@type number
    self.star = 0
    ---@type number
    self.levelCap = 0
end

--- @return void
--- @param data string
function HeroLevelCapConfig:ParseCsv(data)
    self.star = tonumber(data.star)
    self.levelCap = tonumber(data.level_cap)
end