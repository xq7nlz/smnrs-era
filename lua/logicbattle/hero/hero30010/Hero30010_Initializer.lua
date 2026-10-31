--- @class Hero30010_Initializer
Hero30010_Initializer = Class(Hero30010_Initializer, HeroInitializer)

--- @return void
function Hero30010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30010_AttackListener(self.myHero)
end