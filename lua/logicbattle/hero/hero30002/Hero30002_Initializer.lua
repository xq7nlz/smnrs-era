--- @class Hero30002_Initializer
Hero30002_Initializer = Class(Hero30002_Initializer, HeroInitializer)

--- @return void
function Hero30002_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero30002_HpStat(self.myHero)
end