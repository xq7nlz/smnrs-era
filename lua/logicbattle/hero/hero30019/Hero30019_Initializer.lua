--- @class Hero30019_Initializer Elne
Hero30019_Initializer = Class(Hero30019_Initializer, HeroInitializer)

--- @return void
function Hero30019_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero30019_BattleHelper(self.myHero)
end