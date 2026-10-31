--- @class Hero40006_Initializer
Hero40006_Initializer = Class(Hero40006_Initializer, HeroInitializer)

--- @return void
function Hero40006_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero40006_HpStat(self.myHero)
end

--- @return void
function Hero40006_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40006_AttackListener(self.myHero)
    self.myHero.battleListener = Hero40006_BattleListener(self.myHero)
end