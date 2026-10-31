--- @class Hero30011_Initializer : HeroInitializer
Hero30011_Initializer = Class(Hero30011_Initializer, HeroInitializer)

--- @return void
function Hero30011_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.attackController = Hero30011_AttackController(self.myHero)
end

--- @return void
function Hero30011_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30011_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30011_SkillListener(self.myHero)
end