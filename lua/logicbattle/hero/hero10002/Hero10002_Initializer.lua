--- @class Hero10002_Initializer
Hero10002_Initializer = Class(Hero10002_Initializer, HeroInitializer)

--- @return void
function Hero10002_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10002_AttackListener(self.myHero)
end