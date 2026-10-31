--- @class Hero60026_Initializer
Hero60026_Initializer = Class(Hero60026_Initializer, HeroInitializer)

--- @return void
function Hero60026_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60026_AttackListener(self.myHero)
end

--- @return void
function Hero60026_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero60026_HpStat(self.myHero)
end