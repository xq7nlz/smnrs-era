--- @class Hero40007_Initializer
Hero40007_Initializer = Class(Hero40007_Initializer, HeroInitializer)

--- @return void
function Hero40007_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40007_AttackListener(self.myHero)
end
