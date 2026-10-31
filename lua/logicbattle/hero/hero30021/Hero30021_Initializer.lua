--- @class Hero30021_Initializer EarthMaster
Hero30021_Initializer = Class(Hero30021_Initializer, HeroInitializer)

--- @return void
function Hero30021_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30021_AttackListener(self.myHero)
end