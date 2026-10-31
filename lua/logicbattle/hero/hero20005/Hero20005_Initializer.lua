--- @class Hero20005_Initializer
Hero20005_Initializer = Class(Hero20005_Initializer, HeroInitializer)

--- @return void
function Hero20005_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.skillController = Hero20005_SkillController(self.myHero)
end

--- @return void
function Hero20005_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20005_AttackListener(self.myHero)
end

--- @return void
function Hero20005_Initializer:CreateHelpers()
    HeroInitializer.CreateHelpers(self)
    self.myHero.battleHelper = Hero20005_BattleHelper(self.myHero)
end
