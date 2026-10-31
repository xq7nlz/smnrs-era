--- @class Hero20016_Initializer
Hero20016_Initializer = Class(Hero20016_Initializer, HeroInitializer)

--- @return void
function Hero20016_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20016_AttackListener(self.myHero)
end