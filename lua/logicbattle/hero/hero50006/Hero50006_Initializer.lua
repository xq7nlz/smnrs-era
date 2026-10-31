--- @class Hero50006_Initializer
Hero50006_Initializer = Class(Hero50006_Initializer, HeroInitializer)

--- @return void
function Hero50006_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50006_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50006_SkillListener(self.myHero)
    self.myHero.battleListener = Hero50006_BattleListener(self.myHero)
end

--- @return void
function Hero50006_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero50006_AttackController(self.myHero)
end

--- @return void
function Hero50006_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50006_BattleHelper(self.myHero)
end
