--- @class Hero40026_Initializer
Hero40026_Initializer = Class(Hero40026_Initializer, HeroInitializer)

--- @return void
function Hero40026_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40026_AttackListener(self.myHero)
end
