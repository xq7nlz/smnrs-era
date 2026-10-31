--- @class HeroAltarLevelReward
HeroAltarLevelReward = Class(HeroAltarLevelReward)

--- @return void
function HeroAltarLevelReward:Ctor()
    ---@type number
    self.level = nil
    ---@type number
    self.heroShard = nil
    ---@type number
    self.goldRate = nil
    ---@type number
    self.magicPotionRate = nil
    ---@type number
    self.ancientPotionRate = nil
    ---@type number
    self.awakenBookRate = nil
end

--- @return void
--- @param data string
function HeroAltarLevelReward:ParseCsv(data)
    self.level = tonumber(data["level"])
    self.heroShard = tonumber(data["hero_shard"])
    self.goldRate = tonumber(data["gold_rate"])
    self.magicPotionRate = tonumber(data["magic_potion_rate"])
    self.ancientPotionRate = tonumber(data["ancient_potion_rate"])
    self.awakenBookRate = tonumber(data["awaken_book_rate"])
end