--- @class Hero40012_Initializer
Hero40012_Initializer = Class(Hero40012_Initializer, HeroInitializer)

--- @return void
function Hero40012_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40012_AttackListener(self.myHero)
end

--- @return void
function Hero40012_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero40012_BattleHelper(self.myHero)
end
