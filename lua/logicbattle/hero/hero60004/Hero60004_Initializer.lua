--- @class Hero60004_Initializer
Hero60004_Initializer = Class(Hero60004_Initializer, HeroInitializer)

--- @return void
function Hero60004_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero60004_HpStat(self.myHero)
end

--- @return void
function Hero60004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60004_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60004_SkillListener(self.myHero)
end
