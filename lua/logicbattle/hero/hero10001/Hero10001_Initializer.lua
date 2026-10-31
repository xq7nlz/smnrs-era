--- @class Hero10001_Initializer
Hero10001_Initializer = Class(Hero10001_Initializer, HeroInitializer)

--- @return void
function Hero10001_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10001_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10001_SkillListener(self.myHero)
end

--- @return void
function Hero10001_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero10001_BattleHelper(self.myHero)
end