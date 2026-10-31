--- @class Hero20015_Initializer
Hero20015_Initializer = Class(Hero20015_Initializer, HeroInitializer)

--- @return void
function Hero20015_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20015_AttackListener(self.myHero)
end