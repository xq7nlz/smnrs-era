--- @class Hero30001_Initializer
Hero30001_Initializer = Class(Hero30001_Initializer, HeroInitializer)

--- @return void
function Hero30001_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero30001_HpStat(self.myHero)
end

--- @return void
function Hero30001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30001_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30001_SkillListener(self.myHero)
end