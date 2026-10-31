--- @class Hero40027_Initializer : HeroInitializer
Hero40027_Initializer = Class(Hero40027_Initializer, HeroInitializer)

--- @return void
function Hero40027_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero40027_HpStat(self.myHero)
    self.myHero.power = Hero40027_PowerStat(self.myHero)
end

--- @return void
function Hero40027_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero40027_SkillController(self.myHero)
    self.myHero.attackController = Hero40027_AttackController(self.myHero)
end

--- @return void
function Hero40027_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40027_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40027_SkillListener(self.myHero)
end

--- @return void
function Hero40027_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero40027_BattleHelper(self.myHero)
end