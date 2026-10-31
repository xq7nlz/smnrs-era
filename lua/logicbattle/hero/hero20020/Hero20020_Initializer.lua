--- @class Hero20020_Initializer
Hero20020_Initializer = Class(Hero20020_Initializer, HeroInitializer)

--- @return void
function Hero20020_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20020_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20020_SkillListener(self.myHero)
end
