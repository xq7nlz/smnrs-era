--- @class HeroAltarStarReward
HeroAltarStarReward = Class(HeroAltarStarReward)

--- @return void
function HeroAltarStarReward:Ctor()
    ---@type number
    self.star = nil
    ---@type number
    self.heroShard = nil
    ---@type number
    self.gold = nil
    ---@type number
    self.magicPotion = nil
    ---@type number
    self.ancientPotion = nil
    ---@type number
    self.awakenBook = nil
end

--- @return void
--- @param data string
function HeroAltarStarReward:ParseCsv(data)
    self.star = tonumber(data["star"])
    self.heroShard = tonumber(data["hero_shard"])
    self.gold = tonumber(data["gold"])
    self.magicPotion = tonumber(data["magic_potion"])
    self.ancientPotion = tonumber(data["ancient_potion"])
    self.awakenBook = tonumber(data["awaken_book"])
end