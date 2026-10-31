--- @class Hero30014_Initializer
Hero30014_Initializer = Class(Hero30014_Initializer, HeroInitializer)

--- @return void
function Hero30014_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30014_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30014_SkillListener(self.myHero)
end

