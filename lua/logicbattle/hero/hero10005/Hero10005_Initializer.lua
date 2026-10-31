--- @class Hero10005_Initializer
Hero10005_Initializer = Class(Hero10005_Initializer, HeroInitializer)

--- @return void
function Hero10005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10005_AttackListener(self.myHero)
    self.myHero.skillListener = Hero10005_SkillListener(self.myHero)
end

--- @return void
function Hero10005_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero10005_BattleHelper(self.myHero)
end