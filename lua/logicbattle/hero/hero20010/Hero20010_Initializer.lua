--- @class Hero20010_Initializer
Hero20010_Initializer = Class(Hero20010_Initializer, HeroInitializer)

--- @return void
function Hero20010_Initializer:CreateListeners()
    HeroInitializer.CreateListeners(self)
    self.myHero.attackListener = Hero20010_AttackListener(self.myHero)
    self.myHero.battleListener = Hero20010_BattleListener(self.myHero)
    self.myHero.skillListener = Hero20010_SkillListener(self.myHero)
end
