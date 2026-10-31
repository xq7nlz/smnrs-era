--- @class Hero30004_Initializer
Hero30004_Initializer = Class(Hero30004_Initializer, HeroInitializer)

--- @return void
function Hero30004_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero30004_HpStat(self.myHero)
end

--- @return void
function Hero30004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30004_AttackListener(self.myHero)
    self.myHero.battleListener = Hero30004_BattleListener(self.myHero)
    self.myHero.skillListener = Hero30004_SkillListener(self.myHero)
end