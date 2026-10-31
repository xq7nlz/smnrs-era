--- @class Hero50025_Initializer
Hero50025_Initializer = Class(Hero50025_Initializer, HeroInitializer)

--- @return void
function Hero50025_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50025_AttackListener(self.myHero)
end

--- @return void
function Hero50025_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero50025_AttackController(self.myHero)
end
