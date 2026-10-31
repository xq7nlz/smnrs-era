--- @class Hero40020_Initializer
Hero40020_Initializer = Class(Hero40020_Initializer, HeroInitializer)

--- @return void
function Hero40020_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40020_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40020_SkillListener(self.myHero)
end
