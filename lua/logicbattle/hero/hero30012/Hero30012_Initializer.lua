--- @class Hero30012_Initializer
Hero30012_Initializer = Class(Hero30012_Initializer, HeroInitializer)

--- @return void
function Hero30012_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30012_AttackListener(self.myHero)
end

--- @return void
function Hero30012_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero30012_BattleHelper(self.myHero)
end
