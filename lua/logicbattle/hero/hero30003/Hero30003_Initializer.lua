--- @class Hero30003_Initializer
Hero30003_Initializer = Class(Hero30003_Initializer, HeroInitializer)

--- @return void
function Hero30003_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero30003_HpStat(self.myHero)
end

--- @return void
function Hero30003_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30003_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30003_SkillListener(self.myHero)
end