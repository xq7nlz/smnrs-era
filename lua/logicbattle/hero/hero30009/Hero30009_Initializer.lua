--- @class Hero30009_Initializer
Hero30009_Initializer = Class(Hero30009_Initializer, HeroInitializer)

--- @return void
function Hero30009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30009_AttackListener(self.myHero)
end