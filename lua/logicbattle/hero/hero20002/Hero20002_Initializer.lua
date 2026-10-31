--- @class Hero20002_Initializer
Hero20002_Initializer = Class(Hero20002_Initializer, HeroInitializer)

--- @return void
function Hero20002_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20002_AttackListener(self.myHero)
end