--- @class Hero40023_Initializer
Hero40023_Initializer = Class(Hero40023_Initializer, HeroInitializer)

--- @return void
function Hero40023_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40023_AttackListener(self.myHero)
end
