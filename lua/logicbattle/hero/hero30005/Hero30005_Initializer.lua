--- @class Hero30005_Initializer
Hero30005_Initializer = Class(Hero30005_Initializer, HeroInitializer)

--- @return void
function Hero30005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30005_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30005_SkillListener(self.myHero)
end