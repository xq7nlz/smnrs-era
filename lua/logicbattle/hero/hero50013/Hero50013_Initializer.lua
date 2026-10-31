--- @class Hero50013_Initializer
Hero50013_Initializer = Class(Hero50013_Initializer, HeroInitializer)

--- @return void
function Hero50013_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero50013_SkillController(self.myHero)
end

--- @return void
function Hero50013_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero50013_AttackListener(self.myHero)
    self.myHero.skillListener = Hero50013_SkillListener(self.myHero)
end