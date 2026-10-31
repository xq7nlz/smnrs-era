--- @class Hero60023_Initializer
Hero60023_Initializer = Class(Hero60023_Initializer, HeroInitializer)

--- @return void
function Hero60023_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60023_AttackListener(self.myHero)
end