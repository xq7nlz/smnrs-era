--- @class Hero50011_Initializer
Hero50011_Initializer = Class(Hero50011_Initializer, HeroInitializer)

--- @return void
function Hero50011_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero50011_EffectController(self.myHero)
end

--- @return void
function Hero50011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50011_AttackListener(self.myHero)
end

--- @return void
function Hero50011_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero50011_BattleHelper(self.myHero)
end