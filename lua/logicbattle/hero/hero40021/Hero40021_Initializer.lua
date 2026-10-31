--- @class Hero40021_Initializer
Hero40021_Initializer = Class(Hero40021_Initializer, HeroInitializer)

--- @return void
function Hero40021_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40021_AttackListener(self.myHero)
end
