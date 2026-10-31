--- @class Hero40011_Initializer
Hero40011_Initializer = Class(Hero40011_Initializer, HeroInitializer)

--- @return void
function Hero40011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40011_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40011_SkillListener(self.myHero)
end
