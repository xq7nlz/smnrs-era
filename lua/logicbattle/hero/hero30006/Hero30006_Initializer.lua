--- @class Hero30006_Initializer
Hero30006_Initializer = Class(Hero30006_Initializer, HeroInitializer)

--- @return void
function Hero30006_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero30006_BattleHelper(self.myHero)
end