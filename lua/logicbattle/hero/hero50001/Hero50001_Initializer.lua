--- @class Hero50001_Initializer
Hero50001_Initializer = Class(Hero50001_Initializer, HeroInitializer)

--- @return void
function Hero50001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50001_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50001_SkillListener(self.myHero)
    self.myHero.battleListener = Hero50001_BattleListener(self.myHero)
end

--- @return void
function Hero50001_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50001_BattleHelper(self.myHero)
end