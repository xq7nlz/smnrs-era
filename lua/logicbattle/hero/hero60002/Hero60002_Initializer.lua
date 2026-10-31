--- @class Hero60002_Initializer
Hero60002_Initializer = Class(Hero60002_Initializer, HeroInitializer)

--- @return void
function Hero60002_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero60002_HpStat(self.myHero)
end

--- @return void
function Hero60002_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero60002_BattleListener(self.myHero)
end