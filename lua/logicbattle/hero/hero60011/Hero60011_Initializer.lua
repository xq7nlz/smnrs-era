--- @class Hero60011_Initializer
Hero60011_Initializer = Class(Hero60011_Initializer, HeroInitializer)

--- @return void
function Hero60011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60011_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60011_BattleListener(self.myHero)
end

--- @return void
function Hero60011_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero60011_BattleHelper(self.myHero)
end
