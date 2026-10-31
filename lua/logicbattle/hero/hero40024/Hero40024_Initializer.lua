--- @class Hero40024_Initializer
Hero40024_Initializer = Class(Hero40024_Initializer, HeroInitializer)

--- @return void
function Hero40024_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40024_AttackListener(self.myHero)
end
