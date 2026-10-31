--- @class Hero10004_Initializer
Hero10004_Initializer = Class(Hero10004_Initializer, HeroInitializer)

--- @return void
function Hero10004_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero10004_EffectController(self.myHero)
end

--- @return void
function Hero10004_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero10004_BattleHelper(self.myHero)
end

--- @return void
function Hero10004_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10004_AttackListener(self.myHero)
end