--- @class Hero40022_Initializer
Hero40022_Initializer = Class(Hero40022_Initializer, HeroInitializer)

--- @return void
function Hero40022_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40022_AttackListener(self.myHero)
end
