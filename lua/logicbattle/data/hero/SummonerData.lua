--- @class SummonerHeroData
SummonerHeroData = Class(SummonerHeroData, HeroData)

--- @return void
function SummonerHeroData:Ctor()
    HeroData.Ctor(self)
end

--- @return void
--- @param data string
function SummonerHeroData:ParseCsv(data)
    self.attack = tonumber(data.attack)
    self.defense = 0
    self.hp = 1
    self.speed = 0

    self.critRate = tonumber(data.crit_rate)
    self.critDamage = tonumber(data.crit_damage)

    self.accuracy = tonumber(data.accuracy)
    self.dodge = 0

    self.pureDamage = tonumber(data.pure_damage)
    self.skillDamage = tonumber(data.skill_damage)
    self.armorBreak = tonumber(data.armor_break)
    self.reduceDamageReduction = 0

    self.ccResistance = 0
    self.damageReduction = 0

    self:CreateStats()
end