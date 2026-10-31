--- @class Hero40001_Initializer
Hero40001_Initializer = Class(Hero40001_Initializer, HeroInitializer)

--- @return void
function Hero40001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40001_AttackListener(self.myHero)
end