--- @class Hero20012_Initializer
Hero20012_Initializer = Class(Hero20012_Initializer, HeroInitializer)

--- @return void
function Hero20012_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20012_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20012_SkillListener(self.myHero)
end