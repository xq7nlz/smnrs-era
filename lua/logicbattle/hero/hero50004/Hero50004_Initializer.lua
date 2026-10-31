--- @class Hero50004_Initializer
Hero50004_Initializer = Class(Hero50004_Initializer, HeroInitializer)

--- @return void
function Hero50004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero50004_BattleListener(self.myHero)
end

--- @return void
function Hero50004_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50004_BattleHelper(self.myHero)
end
