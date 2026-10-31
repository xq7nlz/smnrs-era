--- @class Hero10011_Initializer
Hero10011_Initializer = Class(Hero10011_Initializer, HeroInitializer)

--- @return void
function Hero10011_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero10011_AttackController(self.myHero)
    self.myHero.skillController = Hero10011_SkillController(self.myHero)
end

--- @return void
function Hero10011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10011_AttackListener(self.myHero)
    self.myHero.battleListener = Hero10011_BattleListener(self.myHero)
    self.myHero.skillListener = Hero10011_SkillListener(self.myHero)
end

--- @return void
function Hero10011_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero10011_BattleHelper(self.myHero)
end