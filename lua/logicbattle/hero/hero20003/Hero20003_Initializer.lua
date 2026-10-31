--- @class Hero20003_Initializer
Hero20003_Initializer = Class(Hero20003_Initializer, HeroInitializer)

--- @return void
function Hero20003_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20003_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20003_SkillListener(self.myHero)
end