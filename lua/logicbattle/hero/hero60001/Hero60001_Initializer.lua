--- @class Hero60001_Initializer
Hero60001_Initializer = Class(Hero60001_Initializer, HeroInitializer)

--- @return void
function Hero60001_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero60001_AttackController(self.myHero)
end

--- @return void
function Hero60001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60001_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60001_BattleListener(self.myHero)
end

--- @return void
function Hero60001_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero60001_BattleHelper(self.myHero)
end