--- @class Hero20024_Initializer
Hero20024_Initializer = Class(Hero20024_Initializer, HeroInitializer)

--- @return void
function Hero20024_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20024_AttackListener(self.myHero)
end