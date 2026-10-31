--- @class Hero60013_Initializer
Hero60013_Initializer = Class(Hero60013_Initializer, HeroInitializer)

--- @return void
function Hero60013_Initializer:CreateControllers()
    HeroInitializer.CreateControllers(self)
    self.myHero.hp = Hero60013_HpStat(self.myHero)
end

--- @return void
function Hero60013_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero60013_AttackListener(self.myHero)
    self.myHero.skillListener = Hero60013_SkillListener(self.myHero)
end