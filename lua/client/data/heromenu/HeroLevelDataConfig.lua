--- @class HeroLevelDataConfig
HeroLevelDataConfig = Class(HeroLevelDataConfig)

--- @return void
function HeroLevelDataConfig:Ctor()
    ---@type number
    self.level = 0
    ---@type number
    self.exp = 0
    ---@type number
    self.gold = 0
    ---@type number
    self.magicPotion = 0
    ---@type number
    self.ancientPotion = 0
    ---@type number
    self.awakenBook = 0
end

--- @return void
--- @param data string
function HeroLevelDataConfig:ParseCsv(data)
    self.level = tonumber(data.level)
    self.exp = tonumber(data.exp)
    self.gold = tonumber(data.gold)
    self.magicPotion = tonumber(data.magic_potion)
    self.ancientPotion = tonumber(data.ancient_potion)
    self.awakenBook = tonumber(data.awaken_book)
end