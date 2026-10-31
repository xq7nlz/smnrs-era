--- @class Hero10019_Initializer
Hero10019_Initializer = Class(Hero10019_Initializer, HeroInitializer)

--- @return void
function Hero10019_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10019_AttackListener(self.myHero)
end
