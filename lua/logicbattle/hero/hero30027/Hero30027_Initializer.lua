--- @class Hero30027_Initializer : HeroInitializer
Hero30027_Initializer = Class(Hero30027_Initializer, HeroInitializer)

--- @return void
function Hero30027_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)

    self.myHero.attack = Hero30027_AttackStat(self.myHero)
    self.myHero.hp = Hero30027_HpStat(self.myHero)
end

--- @return void
function Hero30027_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30027_AttackListener(self.myHero)
    self.myHero.battleListener = Hero30027_BattleListener(self.myHero)
    self.myHero.skillListener = Hero30027_SkillListener(self.myHero)
end

--- @return void
function Hero30027_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero30027_EffectController(self.myHero)
end

--- @return void
function Hero30027_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero30027_BattleHelper(self.myHero)
end
