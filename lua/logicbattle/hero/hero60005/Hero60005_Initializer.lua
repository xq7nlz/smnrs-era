--- @class Hero60005_Initializer : HeroInitializer
Hero60005_Initializer = Class(Hero60005_Initializer, HeroInitializer)

--- @return void
function Hero60005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60005_AttackListener(self.myHero)
end

--- @return void
function Hero60005_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero60005_AttackController(self.myHero)
end

--- @return void
function Hero60005_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero60005_BattleHelper(self.myHero)
end
