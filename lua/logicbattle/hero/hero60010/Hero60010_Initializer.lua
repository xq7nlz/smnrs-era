--- @class Hero60010_Initializer
Hero60010_Initializer = Class(Hero60010_Initializer, HeroInitializer)

--- @return void
function Hero60010_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero60010_HpStat(self.myHero)
end

--- @return void
function Hero60010_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero60010_EffectController(self.myHero)
end

--- @return void
function Hero60010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60010_AttackListener(self.myHero)
    self.myHero.battleListener = Hero60010_BattleListener(self.myHero)
end
