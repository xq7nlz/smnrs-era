--- @class Hero40009_Initializer
Hero40009_Initializer = Class(Hero40009_Initializer, HeroInitializer)

--- @return void
function Hero40009_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.battleListener = Hero40009_BattleListener(self.myHero)
    self.myHero.skillListener = Hero40009_SkillListener(self.myHero)
end

--- @return void
function Hero40009_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero40009_AttackController(self.myHero)
end