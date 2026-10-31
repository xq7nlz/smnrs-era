--- @class Hero40005_Initializer
Hero40005_Initializer = Class(Hero40005_Initializer, HeroInitializer)

--- @return void
function Hero40005_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero40005_HpStat(self.myHero)
end

--- @return void
function Hero40005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40005_AttackListener(self.myHero)
end