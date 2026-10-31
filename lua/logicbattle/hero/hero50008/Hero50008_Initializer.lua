--- @class Hero50008_Initializer
Hero50008_Initializer = Class(Hero50008_Initializer, HeroInitializer)

--- @return void
function Hero50008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50008_AttackListener(self.myHero)
end
