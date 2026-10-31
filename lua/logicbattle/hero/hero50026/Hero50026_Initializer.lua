--- @class Hero50026_Initializer
Hero50026_Initializer = Class(Hero50026_Initializer, HeroInitializer)

--- @return void
function Hero50026_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50026_BattleHelper(self.myHero)
end