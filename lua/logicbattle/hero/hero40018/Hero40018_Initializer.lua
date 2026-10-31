--- @class Hero40018_Initializer
Hero40018_Initializer = Class(Hero40018_Initializer, HeroInitializer)

--- @return void
function Hero40018_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40018_AttackListener(self.myHero)
end
