--- @class Hero40008_Initializer
Hero40008_Initializer = Class(Hero40008_Initializer, HeroInitializer)

--- @return void
function Hero40008_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.effectController = Hero40008_EffectController(self.myHero)
end

--- @return void
function Hero40008_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40008_AttackListener(self.myHero)
end
