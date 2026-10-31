--- @class Hero50012_Initializer
Hero50012_Initializer = Class(Hero50012_Initializer, HeroInitializer)

--- @return void
function Hero50012_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50012_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50012_SkillListener(self.myHero)
    self.myHero.battleListener = Hero50012_BattleListener(self.myHero)
end

--- @return void
function Hero50012_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50012_BattleHelper(self.myHero)
end
