--- @class Hero10013_Initializer
Hero10013_Initializer = Class(Hero10013_Initializer, HeroInitializer)

--- @return void
function Hero10013_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10013_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10013_SkillListener(self.myHero)
end