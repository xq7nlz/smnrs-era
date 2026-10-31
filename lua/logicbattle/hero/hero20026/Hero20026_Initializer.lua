--- @class Hero20026_Initializer
Hero20026_Initializer = Class(Hero20026_Initializer, HeroInitializer)

--- @return void
function Hero20026_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20026_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20026_SkillListener(self.myHero)
end