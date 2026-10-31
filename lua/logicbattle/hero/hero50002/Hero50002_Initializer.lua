--- @class Hero50002_Initializer
Hero50002_Initializer = Class(Hero50002_Initializer, HeroInitializer)

--- @return void
function Hero50002_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50002_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50002_SkillListener(self.myHero)
end

--- @return void
function Hero50002_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50002_BattleHelper(self.myHero)
end