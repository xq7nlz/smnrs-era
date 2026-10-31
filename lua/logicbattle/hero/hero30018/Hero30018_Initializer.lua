--- @class Hero30018_Initializer DeathJester
Hero30018_Initializer = Class(Hero30018_Initializer, HeroInitializer)

--- @return void
function Hero30018_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30018_AttackListener(self.myHero)
end