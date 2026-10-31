--- @class Hero30023_Initializer
Hero30023_Initializer = Class(Hero30023_Initializer, HeroInitializer)

--- @return void
function Hero30023_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30023_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30023_SkillListener(self.myHero)
end
