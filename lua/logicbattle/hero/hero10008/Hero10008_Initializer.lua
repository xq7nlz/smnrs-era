--- @class Hero10008_Initializer
Hero10008_Initializer = Class(Hero10008_Initializer, HeroInitializer)

--- @return void
function Hero10008_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero10008_HpStat(self.myHero)
end

--- @return void
function Hero10008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10008_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10008_SkillListener(self.myHero)
end