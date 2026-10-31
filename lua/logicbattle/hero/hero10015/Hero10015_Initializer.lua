--- @class Hero10015_Initializer
Hero10015_Initializer = Class(Hero10015_Initializer, HeroInitializer)

--- @return void
function Hero10015_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10015_AttackListener(self.myHero)
end