--- @class Hero40019_Initializer
Hero40019_Initializer = Class(Hero40019_Initializer, HeroInitializer)

--- @return void
function Hero40019_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40019_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40019_SkillListener(self.myHero)
end
