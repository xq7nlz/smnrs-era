--- @class Hero10017_Initializer
Hero10017_Initializer = Class(Hero10017_Initializer, HeroInitializer)

--- @return void
function Hero10017_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10017_AttackListener(self.myHero)
end
