--- @class Hero30008_Initializer
Hero30008_Initializer = Class(Hero30008_Initializer, HeroInitializer)

--- @return void
function Hero30008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30008_AttackListener(self.myHero)
end
