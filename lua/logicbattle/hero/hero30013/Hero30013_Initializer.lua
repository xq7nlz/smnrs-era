--- @class Hero30013_Initializer
Hero30013_Initializer = Class(Hero30013_Initializer, HeroInitializer)

--- @return void
function Hero30013_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero30013_BattleListener(self.myHero)
end