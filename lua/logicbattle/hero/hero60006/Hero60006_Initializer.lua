--- @class Hero60006_Initializer
Hero60006_Initializer = Class(Hero60006_Initializer, HeroInitializer)

--- @return void
function Hero60006_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60006_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60006_BattleListener(self.myHero)
end

--- @return void
function Hero60006_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero60006_AttackController(self.myHero)
end

