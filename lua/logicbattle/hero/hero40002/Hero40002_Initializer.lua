--- @class Hero40002_Initializer
Hero40002_Initializer = Class(Hero40002_Initializer, HeroInitializer)

--- @return void
function Hero40002_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40002_AttackListener(self.myHero)
end

--- @return void
function Hero40002_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero40002_SkillController(self.myHero)
end