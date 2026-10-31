--- @class Hero60021_Initializer
Hero60021_Initializer = Class(Hero60021_Initializer, HeroInitializer)

--- @return void
function Hero60021_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero60021_AttackController(self.myHero)
end

--- @return void
function Hero60021_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60021_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60021_BattleListener(self.myHero)
end

--- @return void
function Hero60021_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero60021_BattleHelper(self.myHero)
end