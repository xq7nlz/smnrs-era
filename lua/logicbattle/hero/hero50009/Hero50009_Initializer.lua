--- @class Hero50009_Initializer
Hero50009_Initializer = Class(Hero50009_Initializer, HeroInitializer)

--- @return void
function Hero50009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50009_AttackListener(self.myHero)
end
