--- @class Hero10020_Initializer
Hero10020_Initializer = Class(Hero10020_Initializer, HeroInitializer)

--- @return void
function Hero10020_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10020_AttackListener(self.myHero)
end
