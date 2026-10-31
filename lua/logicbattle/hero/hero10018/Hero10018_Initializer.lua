--- @class Hero10018_Initializer
Hero10018_Initializer = Class(Hero10018_Initializer, HeroInitializer)

--- @return void
function Hero10018_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10018_AttackListener(self.myHero)
end
