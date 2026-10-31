--- @class Hero10006_Initializer
Hero10006_Initializer = Class(Hero10006_Initializer, HeroInitializer)

--- @return void
function Hero10006_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero10006_BattleListener(self.myHero)
end