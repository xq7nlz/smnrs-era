--- @class Hero40004_Initializer
Hero40004_Initializer = Class(Hero40004_Initializer, HeroInitializer)

--- @return void
function Hero40004_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero40004_HpStat(self.myHero)
end

--- @return void
function Hero40004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40004_AttackListener(self.myHero)
end