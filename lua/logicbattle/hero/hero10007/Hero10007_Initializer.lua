--- @class Hero10007_Initializer
Hero10007_Initializer = Class(Hero10007_Initializer, HeroInitializer)

--- @return void
function Hero10007_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10007_AttackListener(self.myHero)
    self.myHero.battleListener = Hero10007_BattleListener(self.myHero)
end

--- @return void
function Hero10007_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero10007_BattleHelper(self.myHero)
end