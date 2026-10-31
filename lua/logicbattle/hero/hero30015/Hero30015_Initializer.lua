--- @class Hero30015_Initializer
Hero30015_Initializer = Class(Hero30015_Initializer, HeroInitializer)

--- @return void
function Hero30015_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30015_AttackListener(self.myHero)
end

