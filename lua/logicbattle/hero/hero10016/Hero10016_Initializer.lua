--- @class Hero10016_Initializer
Hero10016_Initializer = Class(Hero10016_Initializer, HeroInitializer)

--- @return void
function Hero10016_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero10016_AttackListener(self.myHero)
end

--- @return void
function Hero10016_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero10016_SkillController(self.myHero)
end