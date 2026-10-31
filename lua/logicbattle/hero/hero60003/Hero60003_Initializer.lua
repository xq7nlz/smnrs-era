--- @class Hero60003_Initializer
Hero60003_Initializer = Class(Hero60003_Initializer, HeroInitializer)

--- @return void
function Hero60003_Initializer:CreateHeroStats()
    HeroInitializer.CreateHeroStats(self)
    self.myHero.hp = Hero60003_HpStat(self.myHero)
end

--- @return void
function Hero60003_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60003_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60003_SkillListener(self.myHero)
end

--- @return void
function Hero60003_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero60003_BattleHelper(self.myHero)
end
