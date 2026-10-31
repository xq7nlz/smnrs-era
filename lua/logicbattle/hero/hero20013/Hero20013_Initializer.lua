--- @class Hero20013_Initializer
Hero20013_Initializer = Class(Hero20013_Initializer, HeroInitializer)

--- @return void
function Hero20013_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20013_AttackListener(self.myHero)
end