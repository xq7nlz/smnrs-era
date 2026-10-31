--- @class Hero60015_Initializer
Hero60015_Initializer = Class(Hero60015_Initializer, HeroInitializer)

--- @return void
function Hero60015_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60015_AttackListener(self.myHero)
end