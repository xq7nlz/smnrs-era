--- @class Hero40003_Initializer Arryl
Hero40003_Initializer = Class(Hero40003_Initializer, HeroInitializer)

--- @return void
function Hero40003_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero40003_AttackListener(self.myHero)
    self.myHero.skillListener = Hero40003_SkillListener(self.myHero)
end