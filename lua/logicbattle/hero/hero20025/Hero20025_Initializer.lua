--- @class Hero20025_Initializer
Hero20025_Initializer = Class(Hero20025_Initializer, HeroInitializer)

--- @return void
function Hero20025_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20025_AttackListener(self.myHero)
end