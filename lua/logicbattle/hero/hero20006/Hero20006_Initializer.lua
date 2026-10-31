--- @class Hero20006_Initializer
Hero20006_Initializer = Class(Hero20006_Initializer, HeroInitializer)

--- @return void
function Hero20006_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero20006_HpStat(self.myHero)
end

--- @return void
function Hero20006_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20006_AttackListener(self.myHero)
    self.myHero.skillListener = Hero20006_SkillListener(self.myHero)
    self.myHero.battleListener = Hero20006_BattleListener(self.myHero)
end

--- @return void
function Hero20006_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero20006_EffectController(self.myHero)
end
