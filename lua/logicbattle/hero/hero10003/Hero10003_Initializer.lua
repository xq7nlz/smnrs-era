--- @class Hero10003_Initializer
Hero10003_Initializer = Class(Hero10003_Initializer, HeroInitializer)

--- @return void
function Hero10003_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10003_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10003_SkillListener(self.myHero)
end
