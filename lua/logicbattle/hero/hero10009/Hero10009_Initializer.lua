--- @class Hero10009_Initializer
Hero10009_Initializer = Class(Hero10009_Initializer, HeroInitializer)

--- @return void
function Hero10009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10009_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10009_SkillListener(self.myHero)
end