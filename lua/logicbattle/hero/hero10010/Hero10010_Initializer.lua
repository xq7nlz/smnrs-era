--- @class Hero10010_Initializer
Hero10010_Initializer = Class(Hero10010_Initializer, HeroInitializer)

--- @return void
function Hero10010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10010_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10010_SkillListener(self.myHero)
end