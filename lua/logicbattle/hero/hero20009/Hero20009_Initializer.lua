--- @class Hero20009_Initializer
Hero20009_Initializer = Class(Hero20009_Initializer, HeroInitializer)

--- @return void
function Hero20009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20009_AttackListener(self.myHero)
end