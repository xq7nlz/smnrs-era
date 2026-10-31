--- @class Hero30007_Initializer
Hero30007_Initializer = Class(Hero30007_Initializer, HeroInitializer)

--- @return void
function Hero30007_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero30007_AttackListener(self.myHero)
    self.myHero.skillListener = Hero30007_SkillListener(self.myHero)
end

--- @return void
function Hero30007_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero30007_SkillController(self.myHero)
end